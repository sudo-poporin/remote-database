# Changelog

Todos los cambios notables de este paquete se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/)
y el versionado sigue [Semantic Versioning](https://semver.org/lang/es/).

## [3.1.0] - 2026-06-13

### Added

- Parámetro `supabasePublishableKey` en `RemoteDatabaseService.init`.

### Deprecated

- `supabaseAnonKey` en `RemoteDatabaseService.init` — usar
  `supabasePublishableKey`. Se removerá en 4.0.0.

### Fixed

- Se elimina el warning de deprecación de `anonKey` (supabase 2.14) y el
  `// ignore` asociado en `RemoteDatabaseService.init`.

## [3.0.1] - 2026-06-13

### Changed

- Bump `supabase_flutter` de `^2.12.4` a `^2.14.2`.
- Bump `json_annotation` de `^4.11.0` a `^4.12.0`.
- Bump `json_serializable` de `^6.13.2` a `^6.14.0`.

### Fixed

- Se suprime el warning de deprecación de `anonKey` introducido por
  `supabase_flutter 2.14` para mantener el analyzer limpio. La migración
  a `publishableKey` queda como seguimiento (requiere cambio de key en
  los consumers).

## [3.0.0] - Anterior

### Added

- `statusCode` expuesto en los wrappers de `AuthException`.
- Workflow de CI, cobertura al 100%.

### Changed

- Breaking: renombres en la API pública y correcciones de tipos.
