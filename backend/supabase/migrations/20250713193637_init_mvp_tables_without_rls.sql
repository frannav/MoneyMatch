-- ---------------------------------------------------
-- Migration: init_mvp_tables.sql
-- Purpose: Create core tables for MoneyMatch MVP (no RLS)
-- ---------------------------------------------------

-- 1. Create users table: individual user accounts
CREATE TABLE users (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique user identifier
  email          TEXT NOT NULL UNIQUE,                       -- user email address
  password_hash  TEXT NOT NULL,                              -- hashed password
  name           TEXT,                                       -- optional display name
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()          -- record creation timestamp
);

-- 2. Create groups table: shared budgets for a group of users
CREATE TABLE groups (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique group identifier
  name           TEXT NOT NULL,                               -- group name (e.g. “Alice & Bob”)
  global_budget  NUMERIC(12,2) NOT NULL,                      -- monthly shared budget
  currency       CHAR(3)      NOT NULL DEFAULT 'EUR',         -- currency code
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()           -- record creation timestamp
);

-- 3. Create user_groups table: link users to groups with personal budgets
CREATE TABLE user_groups (
  id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- unique record id
  user_id                   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,   -- linked user
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
  user_id        UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,   -- who recorded this expense
  amount         NUMERIC(12,2) NOT NULL,                      -- expense amount
  is_shared      BOOLEAN    NOT NULL DEFAULT TRUE,            -- shared vs. private flag
  description    TEXT,                                        -- optional note
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()           -- timestamp of expense
);
