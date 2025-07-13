# MoneyMatch Backend

## 📋 Descripción

MoneyMatch es una aplicación de gestión de presupuestos compartidos que permite a los usuarios crear grupos familiares o de amigos para administrar gastos conjuntos. El backend está construido con **Supabase** y proporciona una API robusta para la gestión de usuarios, grupos, presupuestos y gastos.

## 🏗️ Arquitectura

### Base de Datos

El proyecto utiliza PostgreSQL a través de Supabase con las siguientes tablas principales:

TO-DO

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

TO-DO

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

TO-DO

## 🔐 Seguridad

### Row Level Security (RLS)

TO-DO

### Autenticación

- JWT tokens con expiración de 1 hora
- Rotación automática de refresh tokens
- Verificación de email opcional
- Límites de rate limiting configurados

## 🔧 Configuración

### Variables de Entorno

// TO-DO .env y .env.example

### Configuración de Email

El sistema incluye un servidor de testing de emails (Inbucket) para desarrollo local. Para producción, configurar SMTP en `config.toml`.

## 📝 Scripts de Base de Datos

### Ejecutar Migraciones

```bash
supabase db reset
```

### Generar Tipos Swift

```bash
supabase gen types --local --lang=swift > database.types.swift
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

### Push migraciones locales
```bash
supabase db push --local
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