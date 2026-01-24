import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_exceptions.freezed.dart';

/// Excepciones del módulo de almacenamiento.
@freezed
abstract class RemoteStorageException
    with _$RemoteStorageException
    implements Exception {
  /// Error al subir archivo.
  const factory RemoteStorageException.uploadFailure({
    required String message,
    String? path,
  }) = RemoteStorageUploadFailure;

  /// Error al descargar archivo.
  const factory RemoteStorageException.downloadFailure({
    required String message,
    String? path,
  }) = RemoteStorageDownloadFailure;

  /// Error al eliminar archivo.
  const factory RemoteStorageException.deleteFailure({
    required String message,
    String? path,
  }) = RemoteStorageDeleteFailure;

  /// Error al obtener URL.
  const factory RemoteStorageException.urlFailure({
    required String message,
    String? path,
  }) = RemoteStorageUrlFailure;

  /// Error al listar archivos.
  const factory RemoteStorageException.listFailure({
    required String message,
    String? bucket,
  }) = RemoteStorageListFailure;

  /// Error al mover/copiar archivo.
  const factory RemoteStorageException.moveFailure({
    required String message,
    String? fromPath,
    String? toPath,
  }) = RemoteStorageMoveFailure;

  /// Archivo no encontrado.
  const factory RemoteStorageException.fileNotFound({
    required String path,
  }) = RemoteStorageFileNotFound;

  /// Bucket no encontrado.
  const factory RemoteStorageException.bucketNotFound({
    required String bucket,
  }) = RemoteStorageBucketNotFound;

  /// Error de permisos.
  const factory RemoteStorageException.permissionDenied({
    required String message,
  }) = RemoteStoragePermissionDenied;

  /// Error desconocido.
  const factory RemoteStorageException.unknown({
    required String message,
  }) = RemoteStorageUnknown;
}
