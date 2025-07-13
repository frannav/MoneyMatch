-- ---------------------------------------------------
-- Migration: init_mvp_tables.sql
-- Purpose: Create core tables for MoneyMatch MVP (no RLS)
-- ---------------------------------------------------

-- 1. Create profiles table: individual user profiles referencing auth.users
CREATE TABLE profiles (
  id             UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,  -- references Supabase auth.users
  updated_at     TIMESTAMPTZ,                                -- last update timestamp
  full_name      TEXT,                                       -- user display name
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()          -- record creation timestamp
);

-- 2. Create groups table: shared budgets for a group of users
CREATE TABLE groups (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique group identifier
  name           TEXT NOT NULL,                               -- group name (e.g. "Alice & Bob")
  global_budget  NUMERIC(12,2) NOT NULL,                      -- monthly shared budget
  currency       CHAR(3)      NOT NULL DEFAULT 'EUR',         -- currency code
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()           -- record creation timestamp
);

-- 3. Create user_groups table: link users to groups with personal budgets
CREATE TABLE user_groups (
  id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique record id
  user_id                   UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,   -- linked user
  group_id                  UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,  -- linked group
  discretionary_budget      NUMERIC(12,2) NOT NULL,                          -- personal budget within group
  discretionary_remaining   NUMERIC(12,2) NOT NULL,                          -- remaining personal budget
  created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),              -- record creation timestamp
  UNIQUE(user_id, group_id)                                                  -- prevent duplicate links
);

-- 4. Create expenses table: records of spending events
CREATE TABLE expenses (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique expense identifier
  group_id       UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,  -- associated group
  user_id        UUID NOT NULL REFERENCES profiles(id) ON DELETE SET NULL,   -- who recorded this expense
  amount         NUMERIC(12,2) NOT NULL,                      -- expense amount
  is_shared      BOOLEAN    NOT NULL DEFAULT TRUE,            -- shared vs. private flag
  description    TEXT,                                        -- optional note
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()           -- timestamp of expense
);

-- ================================================================
-- Trigger to automatically create a profile when a new user signs up via Supabase Auth
-- ================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (new.id, new.raw_user_meta_data->>'full_name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
