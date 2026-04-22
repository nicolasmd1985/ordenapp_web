# Guía de Pruebas Manuales - OrdenApp Web

Esta guía contiene los comandos necesarios para ejecutar las suites de pruebas que han sido estabilizadas y verificadas en el entorno Docker.

## Requisitos Previos

1. El contenedor `ordenapp_web_container` debe estar en ejecución.
2. Los comandos deben ejecutarse desde la raíz del proyecto (`ordenapp_web`).

---

## 1. Pruebas de Modelos (RSpec)

Estas pruebas verifican la lógica de base de datos, asociaciones y métodos del modelo `Subsidiary`.

**Comando:**
```bash
docker exec -it ordenapp_web_container bundle exec rspec spec/models/subsidiary_spec.rb
```

---

## 2. Pruebas de GraphQL (Mutaciones)

Estas pruebas verifican la creación de sucursales a través de la API de GraphQL. 

**Nota importante:** Estas pruebas requieren autenticación mediante JWT. El test se encarga de generarlo usando la clase `JsonWebToken`.

**Comando:**
```bash
docker exec -it ordenapp_web_container bundle exec rspec spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb
```

---

## 3. Resolución de Problemas Comunes

### ¿Por qué falla `bundle exec rspec spec`?
Si intentas correr todos los tests del proyecto con el comando global, es probable que veas muchos errores como `uninitialized constant`. Esto sucede porque el proyecto tiene archivos de prueba antiguos o "legacy" (ej. `ComponentsController`, `OrderRateDecorator`) que no coinciden con el código actual del sistema. 

**Recomendación:** Corre únicamente los archivos de test que han sido validados o estabilizados.

### Errores de "Unauthorized" en GraphQL
La API de GraphQL de OrdenApp no usa la sesión de navegador habitual. Si estás probando manualmente (ej. con Insomnia o Postman), asegúrate de:
1. Obtener un token JWT válido.
2. Enviarlo en el Header: `Authorization: Bearer <tu_token>`.

### Error de "Status must exist" o "Key (id)=(100) already exists"
La mutación de creación de sucursal tiene el ID de status `100` prefijado en el código. Los tests están configurados para usar `Status.find_by(id: 100) || create(:status, id: 100)` para evitar colisiones y asegurar que el registro exista.

---

## 4. Estructura de Archivos Estabilizados

- **Modelo:** `spec/models/subsidiary_spec.rb`
- **Mutación:** `spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb`
- **Factories:** 
  - `spec/factories/users.rb`
  - `spec/factories/subsidiaries.rb`
  - `spec/factories/corporations.rb`
  - `spec/factories/statuses.rb`
