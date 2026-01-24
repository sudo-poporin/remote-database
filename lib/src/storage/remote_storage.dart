import 'dart:io';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:remote_database/src/storage/exceptions/storage_exceptions.dart';
import 'package:remote_database/src/storage/i_remote_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementación de almacenamiento remoto usando Supabase Storage.
class RemoteStorage implements IRemoteStorage {
  /// Crea una instancia de [RemoteStorage].
  RemoteStorage({required SupabaseStorageClient client}) : _client = client;

  final SupabaseStorageClient _client;

  @override
  Future<Either<RemoteStorageException, String>> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List data,
    String? contentType,
    bool upsert = false,
  }) async {
    try {
      final result = await _client.from(bucket).uploadBinary(
            path,
            data,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );
      return Right(result);
    } on StorageException catch (e) {
      return Left(_mapStorageException(e, 'upload', path: path));
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteStorageException, String>> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
    String? contentType,
    bool upsert = false,
  }) async {
    try {
      final result = await _client.from(bucket).upload(
            path,
            file as File,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );
      return Right(result);
    } on StorageException catch (e) {
      return Left(_mapStorageException(e, 'upload', path: path));
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteStorageException, Uint8List>> download({
    required String bucket,
    required String path,
  }) async {
    try {
      final result = await _client.from(bucket).download(path);
      return Right(result);
    } on StorageException catch (e) {
      return Left(_mapStorageException(e, 'download', path: path));
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteStorageException, void>> delete({
    required String bucket,
    required List<String> paths,
  }) async {
    try {
      await _client.from(bucket).remove(paths);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(_mapStorageException(e, 'delete', path: paths.join(', ')));
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Either<RemoteStorageException, String> getPublicUrl({
    required String bucket,
    required String path,
  }) {
    try {
      final url = _client.from(bucket).getPublicUrl(path);
      return Right(url);
    } on Exception catch (e) {
      return Left(
        RemoteStorageException.urlFailure(
          message: e.toString(),
          path: path,
        ),
      );
    }
  }

  @override
  Future<Either<RemoteStorageException, String>> createSignedUrl({
    required String bucket,
    required String path,
    required int expiresInSeconds,
  }) async {
    try {
      final result = await _client.from(bucket).createSignedUrl(
            path,
            expiresInSeconds,
          );
      return Right(result);
    } on StorageException catch (e) {
      return Left(
        RemoteStorageException.urlFailure(
          message: e.message,
          path: path,
        ),
      );
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteStorageException, List<FileObject>>> list({
    required String bucket,
    String? path,
    int? limit,
    int? offset,
    StorageSortBy? sortBy,
  }) async {
    try {
      final searchOptions = SearchOptions(
        limit: limit,
        offset: offset,
        sortBy: sortBy != null
            ? SortBy(column: _mapSortBy(sortBy), order: 'asc')
            : null,
      );

      final result = await _client.from(bucket).list(
            path: path,
            searchOptions: searchOptions,
          );

      return Right(result);
    } on StorageException catch (e) {
      return Left(
        RemoteStorageException.listFailure(
          message: e.message,
          bucket: bucket,
        ),
      );
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  String _mapSortBy(StorageSortBy sortBy) {
    switch (sortBy) {
      case StorageSortBy.name:
        return 'name';
      case StorageSortBy.createdAt:
        return 'created_at';
      case StorageSortBy.updatedAt:
        return 'updated_at';
      case StorageSortBy.lastAccessedAt:
        return 'last_accessed_at';
    }
  }

  @override
  Future<Either<RemoteStorageException, void>> move({
    required String bucket,
    required String fromPath,
    required String toPath,
  }) async {
    try {
      await _client.from(bucket).move(fromPath, toPath);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(
        RemoteStorageException.moveFailure(
          message: e.message,
          fromPath: fromPath,
          toPath: toPath,
        ),
      );
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteStorageException, void>> copy({
    required String bucket,
    required String fromPath,
    required String toPath,
  }) async {
    try {
      await _client.from(bucket).copy(fromPath, toPath);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(
        RemoteStorageException.moveFailure(
          message: e.message,
          fromPath: fromPath,
          toPath: toPath,
        ),
      );
    } on Exception catch (e) {
      return Left(RemoteStorageException.unknown(message: e.toString()));
    }
  }

  RemoteStorageException _mapStorageException(
    StorageException e,
    String operation, {
    String? path,
  }) {
    final message = e.message;

    if (message.contains('not found') || message.contains('404')) {
      return RemoteStorageException.fileNotFound(path: path ?? 'unknown');
    }
    if (message.contains('permission') || message.contains('403')) {
      return RemoteStorageException.permissionDenied(message: message);
    }
    if (message.contains('bucket')) {
      return RemoteStorageException.bucketNotFound(bucket: path ?? 'unknown');
    }

    switch (operation) {
      case 'upload':
        return RemoteStorageException.uploadFailure(
          message: message,
          path: path,
        );
      case 'download':
        return RemoteStorageException.downloadFailure(
          message: message,
          path: path,
        );
      case 'delete':
        return RemoteStorageException.deleteFailure(
          message: message,
          path: path,
        );
      default:
        return RemoteStorageException.unknown(message: message);
    }
  }
}
