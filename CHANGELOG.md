# Changelog

Todos los cambios notables de este paquete se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/)
y el versionado sigue [Semantic Versioning](https://semver.org/lang/es/).

## [5.1.0] - 2026-08-30

### Agregado

- `IRemoteDatabase.upsertReturning`: inserta o actualiza y devuelve el id de la
  fila escrita. `upsert` devuelve `void`, así que quien inserta una fila cuya
  clave primaria genera la base no puede enterarse de cuál le tocó — y esa es
  justo la fila que después se referencia como clave foránea.

  Aditivo: `upsert` no cambia. Cambiarle el tipo de retorno rompería a
  cualquier consumidor que tipee la variable, y eso sería MAJOR.

### Interno

- Bump de dependencias: `freezed` 3.2.5 → 4.0.1, `mockito` 5.6.4 → 5.8.1,
  `build_runner` 2.15.1 → 2.16.0, `json_serializable` 6.14.0 → 6.14.1 y
  `supabase_flutter` 2.17.1 → 2.17.2. El major de `freezed` cambia lo que emite,
  así que los tres `.freezed.dart` y el `.mocks.dart` se regeneraron.

## [5.0.0] - 2026-08-09

### Agregado

- `IRemoteDatabase.insertIfAbsent`: inserta un registro y no falla si la fila ya
  existe. Devuelve el id del registro insertado, o `null` si ya estaba —ese
  `null` es la respuesta a «no lo inserté yo», no un error—.

  Es la versión atómica de «insertar si no está». Consultar primero y escribir
  después deja una ventana entre las dos llamadas por la que cabe otra escritura
  concurrente; acá la decisión la toma la base en una sola sentencia.

  ```dart
  final result = await db.insertIfAbsent(
    table: 'membership',
    data: {'user_id': userId, 'item_id': itemId},
    onConflict: 'user_id,item_id',
  );
  ```

  `onConflict` son las columnas del índice único que define el conflicto,
  separadas por coma. **Tiene que existir un índice único sobre esas columnas**:
  sin él PostgreSQL rechaza la sentencia —`there is no unique or exclusion
  constraint matching the ON CONFLICT specification`— y el método devuelve un
  `Left(RemoteDatabaseExceptions.insertFailure)`. El índice va **antes** de
  desplegar el código que llama a este método.

  Va como método aparte y no como parámetros de `insert`: agregarle `onConflict`
  a `insert` obligaría a que devuelva `int?` en vez de `int`, y eso rompe a
  todos los que ya lo usan.

### Modificado

- `supabase_flutter` sube de `^2.16.0` a `^2.17.1`. Cambian firmas río abajo
  —`StorageBucketApi.listBuckets` gana un posicional opcional y
  `StorageFileApi.createSignedUrl` gana nombrados—, así que los mocks se
  regeneran en este mismo cambio.

- **Breaking:** `IRemoteDatabase` gana un miembro, así que **toda clase que
  implemente la interfaz a mano deja de compilar** con
  `non_abstract_class_inherits_abstract_member`. Los mocks de `mockito` **no**
  están afectados: `Mock` define `noSuchMethod` y el analizador no exige
  declarar los miembros faltantes.

  **Migración.** Si tenés un fake escrito a mano, agregale el método:

  ```dart
  @override
  Future<Either<RemoteDatabaseExceptions, int?>> insertIfAbsent({
    required String table,
    required Map<String, dynamic> data,
    required String onConflict,
    String resultIdColumn = 'id',
    String? schema,
  }) async {
    return Left(
      RemoteDatabaseExceptions.insertFailure(Exception('Network unavailable')),
    );
  }
  ```

## [4.0.0] - 2026-08-03

### Modificado

- **Breaking:** `IRemoteDatabase` gana un miembro, así que **toda clase que
  implemente la interfaz a mano deja de compilar** con
  `non_abstract_class_inherits_abstract_member`. Los mocks de `mockito` **no**
  están afectados: `Mock` define `noSuchMethod` y el analizador no exige
  declarar los miembros faltantes.

  **Migración.** Si tenés un fake escrito a mano, agregale el método:

  ```dart
  @override
  Future<Either<RemoteDatabaseExceptions, void>> deleteWhereIn({
    required String table,
    required String column,
    required List<Object> values,
    required Map<String, Object> where,
    String? schema,
  }) async {
    return Left(
      RemoteDatabaseExceptions.deleteFailure(Exception('Network unavailable')),
    );
  }
  ```

  Si el fake solo existe para simular fallos, `extends Mock implements
  IRemoteDatabase` evita tener que volver a tocarlo en la próxima adición.

### Eliminado

- **Breaking:** `RemoteDatabaseService.init` pierde el parámetro
  `supabaseAnonKey`, y `resolveSupabaseKey` pierde `anonKey`. Estaban deprecados
  desde `3.1.0` con el aviso *"se removerá en 4.0.0"*, y esta es esa versión.

  **Migración:** pasar la key por `supabasePublishableKey`. Si venías usando
  `supabaseAnonKey`, el valor es el mismo, solo cambia el nombre del parámetro.

  ```dart
  // Antes
  await RemoteDatabaseService.init(
    supabaseUrl: url,
    supabaseAnonKey: key,
  );

  // Ahora
  await RemoteDatabaseService.init(
    supabaseUrl: url,
    supabasePublishableKey: key,
  );
  ```

  Verificado que ningún consumidor pasaba el parámetro deprecado.

### Añadido

- `IRemoteDatabase.deleteWhereIn`: elimina en una sola llamada los registros
  cuya columna está dentro de una lista de valores. `delete` resuelve su
  `where` con `.match(...)`, que solo admite igualdad, así que borrar N
  registros identificados por su id costaba N requests.
- `values` y `where` son obligatorios y no pueden venir vacíos: cualquiera de
  los dos vacío devuelve `Left(deleteFailure)` sin emitir el request. `values`
  vacío dejaría el borrado sin acotar, y `where` vacío lo dejaría sin
  condiciones de pertenencia, cruzando entre usuarios si alguna policy de RLS
  no está bien cerrada.
- README: sección de uso y fila en la tabla de la API pública.

> Nota: borrar filas por su propia clave primaria no tiene camino por
> `deleteWhereIn`, porque exige `where`. Para eso sigue estando `delete`, por
> valor.

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
