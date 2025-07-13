# MoneyMatch Backend - Makefile
# Comandos útiles para desarrollo con Supabase

.PHONY: help install start stop restart status reset logs db-reset db-migrate db-rollback db-seed types clean check

# Variables
SUPABASE_DIR = ./supabase

# Comando por defecto
help: ## Mostrar ayuda
	@echo "MoneyMatch Backend - Comandos disponibles:"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# === CONFIGURACIÓN INICIAL ===
install: ## Instalar dependencias y configurar proyecto
	@echo "🔧 Configurando proyecto..."
	@supabase --version || { echo "❌ Supabase CLI no está instalado. Instálalo con: npm install -g supabase"; exit 1; }
	@echo "✅ Supabase CLI encontrado"
	@echo "🚀 Proyecto configurado correctamente"

# === SERVICIOS LOCALES ===
start: ## Iniciar servicios locales de Supabase
	@echo "🚀 Iniciando servicios locales de Supabase..."
	cd $(SUPABASE_DIR) && supabase start

stop: ## Detener servicios locales de Supabase
	@echo "🛑 Deteniendo servicios locales de Supabase..."
	cd $(SUPABASE_DIR) && supabase stop

restart: ## Reiniciar servicios locales de Supabase
	@echo "🔄 Reiniciando servicios locales de Supabase..."
	cd $(SUPABASE_DIR) && supabase stop && supabase start

status: ## Mostrar estado de los servicios
	@echo "📊 Estado de los servicios:"
	cd $(SUPABASE_DIR) && supabase status

# === BASE DE DATOS ===
db-reset: ## Resetear base de datos local
	@echo "🗑️  Reseteando base de datos local..."
	cd $(SUPABASE_DIR) && supabase db reset

db-migrate: ## Aplicar migraciones pendientes
	@echo "🔄 Aplicando migraciones..."
	cd $(SUPABASE_DIR) && supabase migration up

db-rollback: ## Revertir última migración
	@echo "⏪ Revirtiendo última migración..."
	cd $(SUPABASE_DIR) && supabase migration down

db-seed-db: ## Ejecutar seeds de datos de prueba
	@echo "🌱 Ejecutando seed de usuarios y datos de prueba..."
	pnpm run seed-db
	@echo "✅ Seed de usuarios ejecutado"

db-init-mvp-from-migrations: ## Inicializar tablas MVP desde migraciones
	@echo "Reseteando base de datos..."
	cd $(SUPABASE_DIR) && supabase db reset
	@echo "💃 Iniciando tablas MVP con RLS..."
	cd $(SUPABASE_DIR) && supabase db push --local
	@echo "✅ Inicialización completada"

# === MIGRACIONES ===
migration-new: ## Crear nueva migración (usar: make migration-new name=nombre_migracion)
	@if [ -z "$(name)" ]; then \
		echo "❌ Error: Especifica el nombre de la migración"; \
		echo "Uso: make migration-new name=nombre_migracion"; \
		exit 1; \
	fi
	@echo "📝 Creando nueva migración: $(name)"
	cd $(SUPABASE_DIR) && supabase migration new $(name)

migration-diff: ## Generar migración desde diferencias en schema
	@echo "🔍 Generando migración desde diferencias..."
	cd $(SUPABASE_DIR) && supabase db diff --schema public

# === TIPOS Y CÓDIGO ===
types: ## Generar tipos Swift
	@echo "🔧 Generando tipos..."
	cd $(SUPABASE_DIR) && supabase gen types --local --lang=swift > database.types.swift
	@echo "✅ Tipos generados en database.types.swift"

# === DESARROLLO ===
logs: ## Mostrar logs de servicios locales
	@echo "📋 Mostrando logs..."
	cd $(SUPABASE_DIR) && supabase logs

# === LIMPIEZA ===
clean: ## Limpiar archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	cd $(SUPABASE_DIR) && rm -rf .temp/*
	@echo "✅ Limpieza completada"

reset: ## Reset completo del proyecto
	@echo "🔄 Realizando reset completo del proyecto..."
	cd $(SUPABASE_DIR) && supabase stop
	cd $(SUPABASE_DIR) && supabase db reset
	cd $(SUPABASE_DIR) && supabase start
	@echo "✅ Reset completo terminado"

# === VALIDACIÓN ===
check: ## Verificar configuración del proyecto
	@echo "✅ Verificando configuración..."
	@supabase --version || { echo "❌ Supabase CLI no instalado"; exit 1; }
	@echo "✅ Supabase CLI: OK"
	@test -f $(SUPABASE_DIR)/config.toml || { echo "❌ config.toml no encontrado"; exit 1; }
	@echo "✅ Configuración: OK"
	@test -d $(SUPABASE_DIR)/migrations || { echo "❌ Directorio migrations no encontrado"; exit 1; }
	@echo "✅ Migraciones: OK"
	@echo "🎉 Proyecto configurado correctamente"

db-init-and-seed: ## Inicializar tablas MVP desde migraciones y ejecutar seed de datos de prueba
	@echo "🌱 Inicializando tablas MVP desde migraciones..."
	make db-init-mvp-from-migrations
	@echo "🌱 Ejecutando seed de datos de prueba..."
	make db-seed-db
	@echo "✅ Inicialización y seed completados"