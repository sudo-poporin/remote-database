# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Package Overview

`remote_database` is a Dart package that provides a functional programming interface to Supabase services (database CRUD, authentication, and storage). All operations return `Either<Exception, Result>` from `fpdart`, and exceptions are modeled as `freezed` sealed classes for exhaustive pattern matching.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run all tests
flutter test

# Run a single test file
flutter test test/src/query/query_builder_test.dart

# Code generation (freezed classes, mocks)
dart run build_runner build --delete-conflicting-outputs

# Lint
dart analyze
```

## Architecture

Three modules, each following the same pattern: **Interface -> Implementation (with mixins) -> Typed exceptions**.

### Database (`src/remote_database.dart`, `src/i_remote_database.dart`)

CRUD operations (`selectFrom`, `selectSingle`, `insert`, `update`, `upsert`, `delete`) plus a `query()` method that returns a `QueryBuilder`.

### Query Builder (`src/query/`)

Fluent API built via mixin composition on `QueryBuilderBase`:

- `FilterMixin` — `eq`, `neq`, `gt`, `gte`, `lt`, `lte`, `like`, `ilike`, `inFilter`, `not`
- `OrderingMixin` — `order`
- `PaginationMixin` — `limit`, `range`
- `ExecutionMixin` — `execute`, `executeSingle`, `executeMaybeSingle`, `executeCount`

### Auth (`src/auth/`)

`RemoteAuth` implements `IRemoteAuth` using five mixins:

- `AuthCredentialsMixin` — sign in/up/out
- `AuthOAuthMixin` — OAuth providers
- `AuthRecoveryMixin` — password reset, OTP
- `AuthUserMixin` — user metadata updates
- `AuthSessionMixin` — session management, `onAuthStateChange` stream

### Storage (`src/storage/`)

`RemoteStorage` implements `IRemoteStorage` — upload, download, delete, signed URLs, list, move, copy.

### Key Patterns

- **Either pattern**: `Right` = success, `Left` = typed exception. No thrown exceptions in public API.
- **Sealed exceptions**: `RemoteDatabaseExceptions`, `RemoteAuthExceptions`, `RemoteStorageException` — all freezed unions.
- **Schema support**: All database operations accept an optional `schema` parameter (default: `public`).
- **Barrel files**: Every module folder has a barrel file re-exporting its public API. The main entry point is `lib/remote_database.dart`, which also re-exports `supabase_flutter`.

## Testing

- Uses `mockito` with `@GenerateNiceMocks` for mock generation (mocks defined in `test/dependencies/mock_runner_test.dart`).
- After adding new mock annotations, run `dart run build_runner build --delete-conflicting-outputs` to regenerate `*.mocks.dart`.
- Test structure mirrors `lib/src/` under `test/src/`.

## Linting

Uses `very_good_analysis` with these overrides in `analysis_options.yaml`:

- `invalid_annotation_target`: ignored (freezed compatibility)
- `unnecessary_await_in_return`: disabled
- `flutter_style_todos`: disabled
- Generated files (`*.g.dart`, `*.freezed.dart`) excluded from analysis
