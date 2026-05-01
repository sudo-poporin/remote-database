# Remote Database 📡

[![Tests](https://github.com/sudo-poporin/remote-database/actions/workflows/test.yml/badge.svg)](https://github.com/sudo-poporin/remote-database/actions/workflows/test.yml)
[![coverage: 100%](https://img.shields.io/badge/coverage-100%25-brightgreen)](https://github.com/sudo-poporin/remote-database/actions/workflows/test.yml)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)

Paquete para el manejo de bases de datos remotas con Supabase, utilizando
programación funcional con el patrón Either para manejo de errores.

## Características ✨

- Operaciones CRUD completas (Select, Insert, Update, Delete, Upsert)
- Manejo de errores funcional con `Either<Error, Result>`
- Excepciones tipadas con pattern matching (Freezed)
- Soporte para selección de columnas específicas
- Resolución de conflictos en upsert
- **Soporte para múltiples schemas** (nuevo en v1.1.0)

## Instalación 💻

Añade la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  remote_database:
    git:
      url: https://github.com/sudo-poporin/remote-database
      ref: v2.0.6  # Usar versión específica
```

## Configuración 🔧

### Inicialización

```dart
import 'package:remote_database/remote_database.dart';

Future<void> main() async {
  // Inicializar Supabase
  final supabase = await RemoteDatabaseService.init(
    supabaseUrl: 'https://your-project.supabase.co',
    supabaseAnonKey: 'your-anon-key',
  );

  // Crear instancia del repositorio
  final db = RemoteDatabaseBase(client: supabase.client);
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
  schema: 'public', // Opcional, default: 'public'
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
  schema: 'public', // Opcional, default: 'public'
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
  schema: 'public', // Opcional, default: 'public'
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
  schema: 'public', // Opcional, default: 'public'
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
  schema: 'public', // Opcional, default: 'public'
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
  schema: 'public', // Opcional, default: 'public'
);

result.fold(
  (error) => print('Error al eliminar: $error'),
  (_) => print('Eliminado exitosamente'),
);
```

## Query Builder (Nuevo en v1.2.0)

El Query Builder permite construir consultas avanzadas con una API fluida.

### Consulta básica con filtros

```dart
final result = await db.query('transactions')
    .select('id, amount, date')
    .eq('status', 'completed')
    .gte('date', '2024-01-01')
    .lte('date', '2024-12-31')
    .order('date', ascending: false)
    .limit(20)
    .execute();

result.fold(
  (error) => print('Error: $error'),
  (transactions) => print('Transacciones: $transactions'),
);
```

> **Nota:** Encadená métodos con `.` (no con `..`). El cascade combinado
> con `await` no retorna el `Future` de `execute()` y rompe el flujo.

### Filtros disponibles

| Método | Descripción | Ejemplo |
|--------|-------------|---------|
| `eq(column, value)` | Igualdad (=) | `eq('status', 'active')` |
| `neq(column, value)` | Desigualdad (!=) | `neq('status', 'deleted')` |
| `gt(column, value)` | Mayor que (>) | `gt('price', 100)` |
| `gte(column, value)` | Mayor o igual (>=) | `gte('date', '2024-01-01')` |
| `lt(column, value)` | Menor que (<) | `lt('stock', 10)` |
| `lte(column, value)` | Menor o igual (<=) | `lte('date', '2024-12-31')` |
| `like(column, pattern)` | Patrón case-sensitive | `like('name', 'John%')` |
| `ilike(column, pattern)` | Patrón case-insensitive | `ilike('name', '%john%')` |
| `inFilter(column, values)` | IN clause | `inFilter('status', ['a', 'b'])` |
| `not(column, op, value)` | Negación | `not('status', 'eq', 'deleted')` |

### Ordenamiento y paginación

```dart
// Ordenar por múltiples columnas
final result = await db.query('products')
    .order('category')
    .order('name', ascending: false)
    .execute();

// Paginación con limit
final page1 = await db.query('products')
    .limit(10)
    .execute();

// Paginación con range (offset-based)
final page2 = await db.query('products')
    .range(10, 19) // Registros 10-19 (segunda página de 10)
    .execute();
```

### Métodos de ejecución

| Método | Retorno | Descripción |
|--------|---------|-------------|
| `execute()` | `Either<..., List<Map>>` | Lista de registros |
| `executeSingle()` | `Either<..., Map>` | Un solo registro (falla si hay más) |
| `executeMaybeSingle()` | `Either<..., Map?>` | Un registro o null |
| `executeCount()` | `Either<..., int>` | Conteo de registros |

### Ejemplo: Registro único opcional

```dart
final result = await db.query('users')
    .eq('email', 'test@example.com')
    .executeMaybeSingle();

result.fold(
  (error) => print('Error: $error'),
  (user) => user == null
      ? print('Usuario no encontrado')
      : print('Usuario: ${user['name']}'),
);
```

### Ejemplo: Conteo de registros

```dart
final result = await db.query('orders')
    .eq('status', 'pending')
    .executeCount();

result.fold(
  (error) => print('Error: $error'),
  (count) => print('Órdenes pendientes: $count'),
);
```

### Uso con schemas personalizados

Todos los métodos soportan el parámetro `schema` para trabajar con diferentes
esquemas de Supabase:

```dart
// Consultar desde un schema personalizado
final result = await db.selectFrom(
  table: 'products',
  data: {'category': 'electronics'},
  schema: 'ecommerce', // Usa el schema 'ecommerce' en lugar de 'public'
);

// Insertar en un schema específico
final insertResult = await db.insert(
  table: 'orders',
  data: {'product_id': 1, 'quantity': 2},
  schema: 'ecommerce',
);
```

> **Nota:** Si no se especifica `schema`, se usa `'public'` por defecto.

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
| `init(supabaseUrl, supabaseAnonKey)` | `Future<Supabase>` | Inicializa conexión con Supabase |

### RemoteDatabaseBase

| Método | Retorno | Descripción |
|--------|---------|-------------|
| `selectFrom(table, data, [columns], [schema])` | `Either<..., List<Map>>` | Consulta múltiples registros |
| `selectSingle(table, data, [columns], [schema])` | `Either<..., Map>` | Consulta un registro |
| `insert(table, data, [resultIdColumn], [schema])` | `Either<..., int>` | Inserta y retorna ID |
| `update(table, values, where, [resultIdColumn], [schema])` | `Either<..., int>` | Actualiza y retorna ID |
| `upsert(table, data, [onConflict], [schema])` | `Either<..., void>` | Insert o update |
| `delete(table, where, [schema])` | `Either<..., void>` | Elimina registros |
| `query(table, [schema])` | `QueryBuilder` | Crea Query Builder |

> **Nuevo en v1.1.0:** Todos los métodos ahora aceptan el parámetro opcional
> `schema` (default: `'public'`).
>
> **Nuevo en v1.2.0:** Método `query()` para consultas avanzadas con
> Query Builder.

## Autenticación (Nuevo en v1.3.0)

El módulo de autenticación provee un wrapper sobre `GoTrueClient` con el patrón
Either para manejo de errores.

### Configuración

```dart
final auth = RemoteAuth(goTrueClient: supabase.auth);
```

### Sign In / Sign Up / Sign Out

```dart
// Sign in con email/password
final result = await auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password123',
);

result.fold(
  (error) => error.map(
    invalidCredentials: (_) => print('Credenciales inválidas'),
    emailNotConfirmed: (_) => print('Confirma tu email'),
    signInFailure: (e) => print('Error: ${e.message}'),
    // ... otros casos
    orElse: () => print('Error desconocido'),
  ),
  (user) => print('Bienvenido ${user.email}'),
);

// Sign up con metadata opcional
final signUpResult = await auth.signUp(
  email: 'new@example.com',
  password: 'password123',
  metadata: {'name': 'John Doe', 'avatar_url': 'https://...'},
);

// Sign out
final signOutResult = await auth.signOut();
```

### OAuth (Google, Apple, GitHub, etc.)

```dart
final result = await auth.signInWithOAuth(
  provider: OAuthProvider.google,
  redirectTo: 'myapp://callback',
  scopes: ['email', 'profile'],
);
```

### Password Recovery

```dart
// Enviar email de recuperación
await auth.sendPasswordResetEmail(
  email: 'user@example.com',
  redirectTo: 'myapp://reset',
);

// Verificar OTP
final result = await auth.verifyOtp(
  token: '123456',
  type: OtpType.recovery,
  email: 'user@example.com',
);

// Actualizar contraseña
await auth.updatePassword(newPassword: 'newPassword123');
```

### Session Management

```dart
// Stream de cambios de estado
auth.onAuthStateChange.listen((authState) {
  print('Auth event: ${authState.event}');
});

// Getters síncronos
final user = auth.currentUser;
final session = auth.currentSession;
final isLoggedIn = auth.isSignedIn;
final userId = auth.currentUserId;

// Refrescar sesión
final refreshResult = await auth.refreshSession();

// Establecer sesión manualmente
await auth.setSession(accessToken);
```

### Excepciones de Autenticación

| Excepción | Descripción |
|-----------|-------------|
| `invalidCredentials` | Email o password incorrectos |
| `emailNotConfirmed` | El usuario no confirmó su email |
| `userAlreadyExists` | El email ya está registrado |
| `sessionExpired` | La sesión expiró |
| `signInFailure` | Error genérico al iniciar sesión |
| `signUpFailure` | Error genérico al registrarse |
| `signOutFailure` | Error al cerrar sesión |
| `passwordResetFailure` | Error al enviar email de recuperación |
| `otpVerificationFailure` | Error al verificar OTP |
| `updateUserFailure` | Error al actualizar usuario |
| `unknown` | Error no categorizado |

## Storage (Nuevo en v1.4.0)

El módulo de almacenamiento provee un wrapper sobre `SupabaseStorageClient` con
el patrón Either para manejo de errores.

### Configuración

```dart
final storage = RemoteStorage(client: supabase.storage);
```

### Operaciones Básicas

```dart
// Upload desde bytes
final uploadResult = await storage.uploadBytes(
  bucket: 'avatars',
  path: 'user123.png',
  data: imageBytes,
  contentType: 'image/png',
  upsert: true, // Sobrescribir si existe
);

uploadResult.fold(
  (error) => print('Error: $error'),
  (path) => print('Subido a: $path'),
);

// Download
final downloadResult = await storage.download(
  bucket: 'avatars',
  path: 'user123.png',
);

downloadResult.fold(
  (error) => print('Error: $error'),
  (bytes) => print('Descargados ${bytes.length} bytes'),
);

// Delete (uno o varios archivos)
await storage.delete(
  bucket: 'avatars',
  paths: ['user123.png', 'user456.png'],
);

// Obtener URL pública (síncrono)
final urlResult = storage.getPublicUrl(
  bucket: 'avatars',
  path: 'user123.png',
);
```

### URLs Firmadas

```dart
// Crear URL con expiración (para archivos privados)
final signedResult = await storage.createSignedUrl(
  bucket: 'private-docs',
  path: 'contract.pdf',
  expiresInSeconds: 3600, // 1 hora
);

signedResult.fold(
  (error) => print('Error: $error'),
  (url) => print('URL firmada: $url'),
);
```

### Listado de Archivos

```dart
final listResult = await storage.list(
  bucket: 'avatars',
  path: 'users/', // Opcional: directorio
  limit: 100,     // Opcional: límite
  offset: 0,      // Opcional: paginación
  sortBy: StorageSortBy.createdAt, // Opcional: ordenamiento
);

listResult.fold(
  (error) => print('Error: $error'),
  (files) {
    for (final file in files) {
      print('${file.name} - ${file.createdAt}');
    }
  },
);
```

### Mover y Copiar

```dart
// Mover archivo
await storage.move(
  bucket: 'avatars',
  fromPath: 'temp/photo.png',
  toPath: 'users/user123/photo.png',
);

// Copiar archivo
await storage.copy(
  bucket: 'avatars',
  fromPath: 'templates/default.png',
  toPath: 'users/user456/avatar.png',
);
```

### Excepciones de Storage

| Excepción | Descripción |
|-----------|-------------|
| `uploadFailure` | Error al subir archivo |
| `downloadFailure` | Error al descargar archivo |
| `deleteFailure` | Error al eliminar archivo |
| `urlFailure` | Error al generar URL |
| `listFailure` | Error al listar archivos |
| `moveFailure` | Error al mover/copiar archivo |
| `fileNotFound` | Archivo no encontrado |
| `bucketNotFound` | Bucket no existe |
| `permissionDenied` | Sin permisos para la operación |
| `unknown` | Error no categorizado |

### Opciones de Ordenamiento

| StorageSortBy | Descripción |
|---------------|-------------|
| `name` | Ordenar por nombre |
| `createdAt` | Ordenar por fecha de creación |
| `updatedAt` | Ordenar por fecha de actualización |
| `lastAccessedAt` | Ordenar por último acceso |

## Dependencias 📦

- [supabase_flutter](https://pub.dev/packages/supabase_flutter) - Cliente de Supabase
- [fpdart](https://pub.dev/packages/fpdart) - Programación funcional (Either, Option)
- [freezed](https://pub.dev/packages/freezed) - Clases inmutables y sealed unions

## Coverage 📊

El paquete mantiene **100% de cobertura** sobre los archivos testeables.
El workflow de CI corre `flutter test --coverage` en cada push/PR y verifica
el umbral con `min_coverage: 100`.

Generar el reporte localmente:

```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Archivos excluidos del coverage

Los siguientes archivos están marcados con `// coverage:ignore-file` por ser
wrappers de I/O o extension methods no mockeables en unit tests:

- `lib/src/services/remote_database_service.dart` — `Supabase.initialize`
  estático con I/O real.
- `lib/src/remote_database.dart` — encadena `PostgrestFilterBuilder` que
  implementa `Future` (no mockeable razonablemente).
- `lib/src/query/mixins/execution_mixin.dart` — mismo motivo.
- `lib/src/auth/mixins/auth_oauth_mixin.dart` — `signInWithOAuth` es
  extension que invoca `launchUrl` (`url_launcher`).
