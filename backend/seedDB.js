import { createClient } from '@supabase/supabase-js'

// --------------------------
// Config & Environment
// --------------------------
const { API_URL, SERVICE_ROLE_KEY } = process.env

if (!API_URL || !SERVICE_ROLE_KEY) {
    console.error('❌ API_URL and SERVICE_ROLE_KEY must be set in the environment')
    process.exit(1)
}

// --------------------------
// Supabase Admin Client
// --------------------------
const supabaseAdmin = createClient(API_URL, SERVICE_ROLE_KEY)

// --------------------------
// Users to Seed
// --------------------------
/**
 * @typedef {Object} SeedUser
 * @property {string} email - User's email address
 * @property {string} password - User's password
 * @property {string} full_name - User's full name
 */

/**
 * Array of users to seed in the authentication system
 * @type {SeedUser[]}
 */
const usersToSeed = [
    { email: 'alice@test.com', password: 'password123', full_name: 'Alice' },
    { email: 'bob@test.com', password: 'password123', full_name: 'Bob' },
]

// --------------------------
// Seed Auth Users Function
// --------------------------
/**
 * Seeds authentication users in Supabase Auth
 * Creates users with the structure expected by Supabase Auth API
 */
async function seedAuthUsers() {
    console.log(`🔧 Seeding ${usersToSeed.length} auth users...`)

    for (const user of usersToSeed) {
        try {
            /**
             * Auth User Creation Payload
             * @type {Object}
             * @property {string} email - User's email address
             * @property {string} password - User's password
             * @property {boolean} email_confirm - Skip email confirmation
             * @property {Object} user_metadata - Additional user metadata
             * @property {string} user_metadata.full_name - User's full name
             */
            const { data, error } = await supabaseAdmin.auth.admin.createUser({
                email: user.email,
                password: user.password,
                email_confirm: true,                     // skip email confirmation
                user_metadata: { full_name: user.full_name }
            })

            if (error) throw error

            console.log(`✅ Created auth user: ${user.email} (id: ${data.user?.id})`)
        } catch (err) {
            console.error(`⚠️ Failed to create auth user ${user.email}:`, err)
        }
    }

    console.log('🎉 Auth user seeding complete.')
}

// --------------------------
// Seed Application Data Function
// --------------------------
/**
 * Seeds application data including groups, user memberships, and expenses
 * Inserts data into the public schema tables
 */
async function seedAppData() {
    console.log('🔧 Seeding application data...')

    // 1. Obtener IDs de usuarios existentes
    const { data: listRes, error: listError } = await supabaseAdmin.auth.admin.listUsers()
    if (listError) throw listError
    const users = listRes.users
    const alice = users.find(u => u.email === 'alice@test.com')
    const bob = users.find(u => u.email === 'bob@test.com')
    if (!alice || !bob) throw new Error('Usuarios no encontrados en auth')

    // 2. Crear grupo
    /**
     * Group object structure for database insertion
     * @typedef {Object} GroupInsert
     * @property {string} name - Group name
     * @property {number} global_budget - Total budget for the group
     * @property {string} currency - Currency code (ISO 4217)
     */
    const { data: groupData, error: groupError } = await supabaseAdmin
        .from('groups')
        .insert([{ name: 'Test Group', global_budget: 500.00, currency: 'EUR' }])
        .select('id')
    if (groupError) throw groupError
    const group = groupData?.[0]
    if (!group) throw new Error('Error al crear el grupo')

    console.log(`✅ Created group ${group.id}`)

    // 3. Insertar miembros
    /**
     * User Group membership object structure
     * @typedef {Object} UserGroupInsert
     * @property {string} user_id - UUID of the user from auth.users
     * @property {number} group_id - ID of the group
     * @property {number} discretionary_budget - Individual budget allocated to user
     * @property {number} discretionary_remaining - Remaining budget for user
     */
    const members = [
        { user_id: alice.id, group_id: group.id, discretionary_budget: 250.00, discretionary_remaining: 250.00 },
        { user_id: bob.id, group_id: group.id, discretionary_budget: 250.00, discretionary_remaining: 250.00 }
    ]
    const { error: ugError } = await supabaseAdmin.from('user_groups').insert(members)
    if (ugError) throw ugError
    console.log('✅ Inserted user_groups')

    // 4. Insertar un gasto
    /**
     * Expense object structure for database insertion
     * @typedef {Object} ExpenseInsert
     * @property {number} group_id - ID of the group this expense belongs to
     * @property {string} user_id - UUID of the user who made the expense
     * @property {number} amount - Amount of the expense
     * @property {boolean} is_shared - Whether the expense is shared among group members
     * @property {string} description - Description of the expense
     */
    const expense = { group_id: group.id, user_id: alice.id, amount: 25.00, is_shared: true, description: 'Café' }
    const { error: expError } = await supabaseAdmin.from('expenses').insert([expense])
    if (expError) throw expError
    console.log('✅ Inserted expenses')

    console.log('🎉 Application data seeding complete.')
}

// --------------------------
// Execute
// --------------------------
async function main() {
    await seedAuthUsers()
    await seedAppData()
}

main().catch(err => {
    console.error('Fatal error during seeding:', err)
    process.exit(1)
}) 