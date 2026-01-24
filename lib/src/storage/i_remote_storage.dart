import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:remote_database/src/storage/exceptions/storage_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Opciones de ordenamiento para listado.
enum StorageSortBy {
  /// Ordenar por nombre.
  name,

  /// Ordenar por fecha de creación.
  createdAt,

  /// Ordenar por fecha de actualización.
  updatedAt,

  /// Ordenar por fecha de último acceso.
  lastAccessedAt,
}

/// Interface para operaciones de almacenamiento.
abstract interface class IRemoteStorage {
  /// Sube un archivo desde bytes.
  Future<Either<RemoteStorageException, String>> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List data,
    String? contentType,
    bool upsert = false,
  });

  /// Sube un archivo desde File (solo disponible en mobile/desktop).
  Future<Either<RemoteStorageException, String>> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
    String? contentType,
    bool upsert = false,
  });

  /// Descarga un archivo como bytes.
  Future<Either<RemoteStorageException, Uint8List>> download({
    required String bucket,
    required String path,
  });

  /// Elimina uno o más archivos.
  Future<Either<RemoteStorageException, void>> delete({
    required String bucket,
    required List<String> paths,
  });

  /// Obtiene la URL pública de un archivo.
  Either<RemoteStorageException, String> getPublicUrl({
    required String bucket,
    required String path,
  });

  /// Genera una URL firmada con expiración.
  Future<Either<RemoteStorageException, String>> createSignedUrl({
    required String bucket,
    required String path,
    required int expiresInSeconds,
  });

  /// Lista archivos en un directorio.
  Future<Either<RemoteStorageException, List<FileObject>>> list({
    required String bucket,
    String? path,
    int? limit,
    int? offset,
    StorageSortBy? sortBy,
  });

  /// Mueve un archivo a otra ubicación.
  Future<Either<RemoteStorageException, void>> move({
    required String bucket,
    required String fromPath,
    required String toPath,
  });

  /// Copia un archivo a otra ubicación.
  Future<Either<RemoteStorageException, void>> copy({
    required String bucket,
    required String fromPath,
    required String toPath,
  });
}
