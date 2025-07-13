WITH alice AS (
   SELECT id AS user_id FROM auth.users WHERE email = 'alice@test.com'
 ),
 bob AS (
   SELECT id AS user_id FROM auth.users WHERE email = 'bob@test.com'
 ),
 new_group AS (
   INSERT INTO public.groups (name, global_budget, currency, created_at)
   VALUES ('Test Group', 500.00, 'EUR', now())
   RETURNING id AS group_id
 )
-- Insertar membresías
INSERT INTO public.user_groups (user_id, group_id, discretionary_budget, discretionary_remaining, created_at)
SELECT a.user_id, ng.group_id, 250.00, 250.00, now() FROM alice a, new_group ng;

INSERT INTO public.user_groups (user_id, group_id, discretionary_budget, discretionary_remaining, created_at)
SELECT b.user_id, ng.group_id, 250.00, 250.00, now() FROM bob b, new_group ng;

-- Insertar gastos de ejemplo
WITH grp AS (SELECT group_id AS id FROM new_group),
     alice AS (SELECT user_id FROM alice)
INSERT INTO public.expenses (group_id, user_id, amount, is_shared, description, created_at)
SELECT g.id, a.user_id, 25.00, TRUE, 'Café', now() FROM grp g, alice a;