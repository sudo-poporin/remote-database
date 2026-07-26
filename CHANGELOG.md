# Changelog

Todos los cambios notables de este paquete se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/)
y el versionado sigue [Semantic Versioning](https://semver.org/lang/es/).

## [3.1.2] - 2026-07-26

### Interno

- Bump `supabase_flutter` de `^2.15.0` a `^2.16.0` (incluye `gotrue 2.26.0` y
  `storage_client 2.6.0`).
- Bump `build_runner` de `^2.15.0` a `^2.15.1`.
- Se regeneran los mocks de `mockito` para cubrir los nuevos parámetros
  nombrados de `StorageFileApi` y `GoTrueClient`.
- `RemoteStorage.list`: se elimina el argumento redundante `order: 'asc'` en
  `SortBy` (ahora es el valor por defecto de `storage_client`).
- CHANGELOG: los títulos de sección pasan a español (`Añadido`, `Modificado`,
  `Corregido`, `Obsoleto`).

> Nota: `mockito` se mantiene en `^5.6.4`. La versión `5.7.0` requiere
> `analyzer ^13.0.0`, incompatible con `freezed 3.2.5` (limita
> `analyzer <11.0.0`). Sigue como seguimiento para cuando `freezed 4` sea
> estable.

## [3.1.1] - 2026-06-28

### Interno

- Bump `supabase_flutter` de `^2.14.2` a `^2.15.0`.
- Bump `very_good_analysis` de `^10.2.0` a `^10.3.0`.
- `.gitignore`: ignorar `AGENTS.md` y `graphify-out/`.
- `analysis_options.yaml`: excluir los mocks generados (`test/**.mocks.dart`)
  del análisis para evitar warnings `experimental_member_use` de la API de
  passkeys de `gotrue`.

> Nota: `mockito` no se actualiza a `5.7.0` porque requiere `analyzer
> ^13.0.0`, incompatible con `freezed 3.2.5` (limita `analyzer <11.0.0`).
> Queda como seguimiento para cuando `freezed 4` sea estable.

## [3.1.0] - 2026-06-13

### Añadido

- Parámetro `supabasePublishableKey` en `RemoteDatabaseService.init`.

### Obsoleto

- `supabaseAnonKey` en `RemoteDatabaseService.init` — usar
  `supabasePublishableKey`. Se removerá en 4.0.0.

### Corregido

- Se elimina el warning de deprecación de `anonKey` (supabase 2.14) y el
  `// ignore` asociado en `RemoteDatabaseService.init`.

## [3.0.1] - 2026-06-13

### Modificado

- Bump `supabase_flutter` de `^2.12.4` a `^2.14.2`.
- Bump `json_annotation` de `^4.11.0` a `^4.12.0`.
- Bump `json_serializable` de `^6.13.2` a `^6.14.0`.

### Corregido

- Se suprime el warning de deprecación de `anonKey` introducido por
  `supabase_flutter 2.14` para mantener el analyzer limpio. La migración
  a `publishableKey` queda como seguimiento (requiere cambio de key en
  los consumers).

## [3.0.0] - Anterior

### Añadido

- `statusCode` expuesto en los wrappers de `AuthException`.
- Workflow de CI, cobertura al 100%.

### Modificado

- Breaking: renombres en la API pública y correcciones de tipos.
