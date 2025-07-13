# MoneyMatch Backend

## 📋 Descripción

MoneyMatch es una aplicación de gestión de presupuestos compartidos que permite a los usuarios crear grupos familiares o de amigos para administrar gastos conjuntos. El backend está construido con **Supabase** y proporciona una API robusta para la gestión de usuarios, grupos, presupuestos y gastos.

## 🏗️ Arquitectura

### Base de Datos

El proyecto utiliza PostgreSQL a través de Supabase con las siguientes tablas principales:

- **`users`**: Cuentas individuales de usuarios
- **`groups`**: Presupuestos compartidos para grupos de usuarios
- **`user_groups`**: Relación entre usuarios y grupos con presupuestos discrecionales
- **`expenses`**: Registros de gastos (compartidos o privados)

### Seguridad

- **Row Level Security (RLS)**: Implementado en todas las tablas
- **Autenticación**: Basada en JWT a través de Supabase Auth
- **Autorización**: Políticas granulares que aseguran que los usuarios solo puedan acceder a sus propios datos y grupos

## 🚀 Características Principales

### Gestión de Usuarios
- Registro y autenticación segura
- Perfiles de usuario personalizables
- Gestión de contraseñas con hash seguro

### Grupos y Presupuestos
- Creación de grupos compartidos
- Asignación de presupuestos globales por grupo
- Presupuestos discrecionales individuales dentro de cada grupo
- Soporte para múltiples divisas (por defecto EUR)

### Gestión de Gastos
- Registro de gastos compartidos y privados
- Historial completo de transacciones
- Asociación automática con grupos y usuarios
- Timestamps automáticos para auditoría

## 📁 Estructura del Proyecto

```
backend/
├── supabase/
│   ├── config.toml          # Configuración de Supabase
│   └── sql/
│       └── v1.sql           # Schema inicial de la base de datos
└── README.md
```

## 🛠️ Configuración Local

### Prerrequisitos

- [Supabase CLI](https://supabase.com/docs/guides/cli)
- Docker (para el entorno local de Supabase)

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Inicializar Supabase**
   ```bash
   supabase start
   ```

3. **Aplicar migraciones**
   ```bash
   supabase db reset
   ```

### URLs de Desarrollo

Una vez iniciado el entorno local, tendrás acceso a:

- **API**: `http://127.0.0.1:54321`
- **Supabase Studio**: `http://127.0.0.1:54323`
- **Inbucket (Email testing)**: `http://127.0.0.1:54324`

## 📊 Esquema de Base de Datos

### Tablas Principales

#### Users
```sql
- id: UUID (Primary Key)
- email: TEXT (Unique)
- password_hash: TEXT
- name: TEXT (Optional)
- created_at: TIMESTAMPTZ
```

#### Groups
```sql
- id: UUID (Primary Key)
- name: TEXT
- global_budget: NUMERIC(12,2)
- currency: CHAR(3)
- created_at: TIMESTAMPTZ
```

#### User_Groups
```sql
- id: UUID (Primary Key)
- user_id: UUID (Foreign Key)
- group_id: UUID (Foreign Key)
- discretionary_budget: NUMERIC(12,2)
- discretionary_remaining: NUMERIC(12,2)
- created_at: TIMESTAMPTZ
```

#### Expenses
```sql
- id: UUID (Primary Key)
- group_id: UUID (Foreign Key)
- user_id: UUID (Foreign Key)
- amount: NUMERIC(12,2)
- is_shared: BOOLEAN
- description: TEXT
- created_at: TIMESTAMPTZ
```

## 🔐 Seguridad

### Row Level Security (RLS)

Todas las tablas implementan RLS con políticas específicas:

- **Users**: Solo pueden ver y modificar sus propios registros
- **Groups**: Solo los miembros pueden ver y modificar grupos
- **User_Groups**: Los usuarios solo pueden gestionar su propia membresía
- **Expenses**: Solo los miembros del grupo pueden ver y gestionar gastos

### Autenticación

- JWT tokens con expiración de 1 hora
- Rotación automática de refresh tokens
- Verificación de email opcional
- Límites de rate limiting configurados

## 🔧 Configuración

### Variables de Entorno

Las siguientes variables de entorno pueden ser configuradas:

```bash
OPENAI_API_KEY=your_openai_key_here
SUPABASE_AUTH_SMS_TWILIO_AUTH_TOKEN=your_twilio_token
```

### Configuración de Email

El sistema incluye un servidor de testing de emails (Inbucket) para desarrollo local. Para producción, configurar SMTP en `config.toml`.

## 📝 Scripts de Base de Datos

### Ejecutar Migraciones

```bash
supabase db reset
```

### Generar Tipos TypeScript

```bash
supabase gen types typescript --local > database.types.ts
```

### Hacer Backup

```bash
supabase db dump --local > backup.sql
```

## 🔄 Desarrollo

### Añadir Nuevas Migraciones

```bash
supabase migration new nombre_migracion
```

### Resetear Base de Datos

```bash
supabase db reset
```

### Ver Logs

```bash
supabase logs -f
```

## 🚀 Despliegue

### Desplegar a Supabase

```bash
supabase link --project-ref your-project-ref
supabase db push
```

### Configurar Producción

1. Configurar variables de entorno en el dashboard de Supabase
2. Ajustar configuración de SMTP
3. Configurar dominios permitidos para redirects
4. Ajustar límites de rate limiting según necesidades

## 📚 Recursos Adicionales

- [Documentación de Supabase](https://supabase.com/docs)
- [Guía de RLS](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase CLI](https://supabase.com/docs/guides/cli)

**MoneyMatch** - Gestión inteligente de presupuestos compartidos 💰✨ 