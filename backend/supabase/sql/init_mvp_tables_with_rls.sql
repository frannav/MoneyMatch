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

-- ================================================================
-- Enable Row Level Security on each table (must be enabled for RLS to apply) :contentReference[oaicite:0]{index=0}
-- ================================================================
ALTER TABLE users        ENABLE ROW LEVEL SECURITY;            -- protect user records :contentReference[oaicite:1]{index=1}
ALTER TABLE groups       ENABLE ROW LEVEL SECURITY;            -- protect group data :contentReference[oaicite:2]{index=2}
ALTER TABLE user_groups  ENABLE ROW LEVEL SECURITY;            -- protect membership links :contentReference[oaicite:3]{index=3}
ALTER TABLE expenses     ENABLE ROW LEVEL SECURITY;            -- protect expense records :contentReference[oaicite:4]{index=4}

-- ================================================================
-- Policies for users table
-- Allow each authenticated user to view and modify only their own user record :contentReference[oaicite:5]{index=5}
-- ================================================================
-- SELECT: user can view their own record
CREATE POLICY "Users can view own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING ( auth.uid() = id );                                  -- only rows matching current user :contentReference[oaicite:6]{index=6}

-- INSERT: user can create their own record
CREATE POLICY "Users can insert own profile"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK ( auth.uid() = id );                              -- ensure new row belongs to current user :contentReference[oaicite:7]{index=7}

-- UPDATE: user can update their own record
CREATE POLICY "Users can update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING    ( auth.uid() = id )                                 -- allow update of owned rows :contentReference[oaicite:8]{index=8}
  WITH CHECK( auth.uid() = id );                               -- ensure ownership remains after update :contentReference[oaicite:9]{index=9}

-- DELETE: user can delete their own record
CREATE POLICY "Users can delete own profile"
  ON users
  FOR DELETE
  TO authenticated
  USING ( auth.uid() = id );                                   -- allow deletion of owned rows :contentReference[oaicite:10]{index=10}

-- ================================================================
-- Policies for groups table
-- Only members of a group may view or modify that group :contentReference[oaicite:11]{index=11}
-- ================================================================
-- SELECT: authenticated users only see groups they belong to
CREATE POLICY "Members can view groups"
  ON groups
  FOR SELECT
  TO authenticated
  USING ( id IN (
    SELECT group_id FROM user_groups WHERE user_id = auth.uid()
  ));                                                          -- restrict to user’s groups :contentReference[oaicite:12]{index=12}

-- INSERT: user may create a new group if they become first member
CREATE POLICY "Members can create groups"
  ON groups
  FOR INSERT
  TO authenticated
  WITH CHECK ( TRUE );                                         -- allow any authenticated user to create :contentReference[oaicite:13]{index=13}

-- UPDATE: only allow changing budget fields if member
CREATE POLICY "Members can update groups"
  ON groups
  FOR UPDATE
  TO authenticated
  USING ( id IN (
    SELECT group_id FROM user_groups WHERE user_id = auth.uid()
  ))
  WITH CHECK ( id IN (
    SELECT group_id FROM user_groups WHERE user_id = auth.uid()
  ));                                                          -- ensure continued membership :contentReference[oaicite:14]{index=14}

-- DELETE: only allow group deletion by members (could be restricted further later)
CREATE POLICY "Members can delete groups"
  ON groups
  FOR DELETE
  TO authenticated
  USING ( id IN (
    SELECT group_id FROM user_groups WHERE user_id = auth.uid()
  ));                                                          -- restrict delete to group members :contentReference[oaicite:15]{index=15}

-- ================================================================
-- Policies for user_groups table
-- Users can only manage their own membership link :contentReference[oaicite:16]{index=16}
-- ================================================================
-- SELECT: view only own membership records
CREATE POLICY "Users can view own membership"
  ON user_groups
  FOR SELECT
  TO authenticated
  USING ( user_id = auth.uid() );                             -- only own rows :contentReference[oaicite:17]{index=17}

-- INSERT: allow joining a group
CREATE POLICY "Users can insert membership"
  ON user_groups
  FOR INSERT
  TO authenticated
  WITH CHECK ( user_id = auth.uid() );                         -- ensure membership row belongs to user :contentReference[oaicite:18]{index=18}

-- UPDATE: allow updating only own discretionary values
CREATE POLICY "Users can update own membership"
  ON user_groups
  FOR UPDATE
  TO authenticated
  USING ( user_id = auth.uid() )
  WITH CHECK ( user_id = auth.uid() );                         -- cannot modify others’ membership :contentReference[oaicite:19]{index=19}

-- DELETE: allow leaving a group
CREATE POLICY "Users can delete own membership"
  ON user_groups
  FOR DELETE
  TO authenticated
  USING ( user_id = auth.uid() );                             -- can only remove own link :contentReference[oaicite:20]{index=20}

-- ================================================================
-- Policies for expenses table
-- Only group members can view or manage expenses in their group :contentReference[oaicite:21]{index=21}
-- ================================================================
-- SELECT: view expenses if user is member of that group
CREATE POLICY "Members can view expenses"
  ON expenses
  FOR SELECT
  TO authenticated
  USING ( group_id IN (
    SELECT group_id FROM user_groups WHERE user_id = auth.uid()
  ));                                                          -- ensure group membership :contentReference[oaicite:22]{index=22}

-- INSERT: allow inserting expense if user belongs to group and records own user_id
CREATE POLICY "Members can insert expenses"
  ON expenses
  FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid()                                      -- expense must be recorded by this user :contentReference[oaicite:23]{index=23}
    AND group_id IN (SELECT group_id FROM user_groups WHERE user_id = auth.uid())
  );                                                           -- ensure group membership :contentReference[oaicite:24]{index=24}

-- UPDATE: allow updating only expenses they created in their groups
CREATE POLICY "Members can update expenses"
  ON expenses
  FOR UPDATE
  TO authenticated
  USING (
    user_id = auth.uid()
    AND group_id IN (SELECT group_id FROM user_groups WHERE user_id = auth.uid())
  )
  WITH CHECK (
    user_id = auth.uid()                                      -- cannot reassign expense to another user :contentReference[oaicite:25]{index=25}
  );

-- DELETE: allow deleting only expenses they created in their groups
CREATE POLICY "Members can delete expenses"
  ON expenses
  FOR DELETE
  TO authenticated
  USING (
    user_id = auth.uid()
    AND group_id IN (SELECT group_id FROM user_groups WHERE user_id = auth.uid())
  );                                                           -- restrict deletes to own expenses :contentReference[oaicite:26]{index=26}
