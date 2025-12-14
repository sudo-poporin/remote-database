# Remote Database 📡

Paquete para el manejo de bases de datos remotas con Supabase, utilizando
programación funcional con el patrón Either para manejo de errores.

## Características ✨

- Operaciones CRUD completas (Select, Insert, Update, Delete, Upsert)
- Manejo de errores funcional con `Either<Error, Result>`
- Excepciones tipadas con pattern matching (Freezed)
- Soporte para selección de columnas específicas
- Resolución de conflictos en upsert

## Instalación 💻

Añade la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  remote_database:
    git:
      url: https://github.com/sudo-poporin/remote-database
      ref: v1.0.7  # Usar versión específica
```

## Configuración 🔧

### Inicialización

```dart
import 'package:remote_database/remote_database.dart';

Future<void> main() async {
  // Inicializar Supabase
  final supabase = await RemoteDatabaseService.init(
    supabaseUrl: 'https://your-project.supabase.co',
    supabaseAnnonKey: 'your-anon-key',
  );

  // Crear instancia del repositorio
  final db = RemoteDatabase(client: supabase.client);
}
```

## Uso 📖

Todos los métodos retornan `Either<RemoteDatabaseExceptions, T>`:

- **Right(valor)** → Operación exitosa
- **Left(excepción)** → Error con tipo específico

### Consultar múltiples registros

```dart
final result = await db.selectFrom(
  table: 'users',
  data: {'active': true},
  columns: 'id, name, email', // Opcional, default: '*'
);

result.fold(
  (error) => print('Error: $error'),
  (users) => print('Usuarios: $users'), // List<Map<String, dynamic>>
);
```

> **Nota:** Si no hay datos, retorna `Right([])` (lista vacía), no un error.

### Consultar un registro único

```dart
final result = await db.selectSingle(
  table: 'users',
  data: {'id': 123},
  columns: 'id, name, email',
);

result.fold(
  (error) => print('Error: $error'),
  (user) => print('Usuario: $user'), // Map<String, dynamic>
);
```

> **Nota:** Si no hay datos, retorna `Right({})` (mapa vacío), no un error.

### Insertar registro

```dart
final result = await db.insert(
  table: 'users',
  data: {'name': 'Juan', 'email': 'juan@email.com'},
  resultIdColumn: 'id', // Opcional, default: 'id'
);

result.fold(
  (error) => print('Error al insertar: $error'),
  (id) => print('ID insertado: $id'), // int
);
```

### Actualizar registro

```dart
final result = await db.update(
  table: 'users',
  values: {'name': 'Juan Carlos'},
  where: {'id': 123},
  resultIdColumn: 'id',
);

result.fold(
  (error) => print('Error al actualizar: $error'),
  (id) => print('ID actualizado: $id'), // int
);
```

### Upsert (Insert o Update)

```dart
final result = await db.upsert(
  table: 'users',
  data: {'id': 123, 'name': 'Juan', 'email': 'juan@email.com'},
  onConflict: 'id', // Columna para detectar conflicto
);

result.fold(
  (error) => print('Error en upsert: $error'),
  (_) => print('Upsert exitoso'),
);
```

### Eliminar registro

```dart
final result = await db.delete(
  table: 'users',
  where: {'id': 123},
);

result.fold(
  (error) => print('Error al eliminar: $error'),
  (_) => print('Eliminado exitosamente'),
);
```

## Manejo de Errores 🚨

### Tipos de excepciones

El paquete utiliza `RemoteDatabaseExceptions` (sealed class con Freezed):

| Excepción | Descripción |
|-----------|-------------|
| `insertFailure` | Error al insertar |
| `updateFailure` | Error al actualizar |
| `upsertFailure` | Error en upsert |
| `deleteFailure` | Error al eliminar |
| `selectFailure` | Error en selectFrom |
| `selectSingleFailure` | Error en selectSingle |
| `noDataFound` | Registro no encontrado |

### Pattern matching con excepciones

```dart
result.fold(
  (error) => error.map(
    insertFailure: (e) => print('Insert falló: ${e.error}'),
    updateFailure: (e) => print('Update falló: ${e.error}'),
    upsertFailure: (e) => print('Upsert falló: ${e.error}'),
    deleteFailure: (e) => print('Delete falló: ${e.error}'),
    selectFailure: (e) => print('Select falló: ${e.error}'),
    selectSingleFailure: (e) => print('SelectSingle falló: ${e.error}'),
    noDataFound: (_) => print('No se encontraron datos'),
  ),
  (data) => print('Éxito: $data'),
);
```

### Manejo simplificado con maybeMap

```dart
result.fold(
  (error) => error.maybeMap(
    noDataFound: (_) => print('Sin resultados'),
    orElse: () => print('Error de base de datos'),
  ),
  (data) => print('Datos: $data'),
);
```

## API Reference 📚

### RemoteDatabaseService

| Método | Retorno | Descripción |
|--------|---------|-------------|
| `init(supabaseUrl, supabaseAnnonKey)` | `Future<Supabase>` | Inicializa conexión con Supabase |

### RemoteDatabase

| Método | Retorno | Descripción |
|--------|---------|-------------|
| `selectFrom(table, data, [columns])` | `Either<..., List<Map>>` | Consulta múltiples registros |
| `selectSingle(table, data, [columns])` | `Either<..., Map>` | Consulta un registro |
| `insert(table, data, [resultIdColumn])` | `Either<..., int>` | Inserta y retorna ID |
| `update(table, values, where, [resultIdColumn])` | `Either<..., int>` | Actualiza y retorna ID |
| `upsert(table, data, [onConflict])` | `Either<..., void>` | Insert o update |
| `delete(table, where)` | `Either<..., void>` | Elimina registros |

## Dependencias 📦

- [supabase_flutter](https://pub.dev/packages/supabase_flutter) - Cliente de Supabase
- [fpdart](https://pub.dev/packages/fpdart) - Programación funcional (Either, Option)
- [freezed](https://pub.dev/packages/freezed) - Clases inmutables y sealed unions
