import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_exceptions.freezed.dart';

/// Excepciones del módulo de almacenamiento.
@freezed
abstract class RemoteStorageException
    with _$RemoteStorageException
    implements Exception {
  /// Error al subir archivo.
  const factory uploadFailure({required String message, String? path}) =
      RemoteStorageUploadFailure;

  /// Error al descargar archivo.
  const factory downloadFailure({required String message, String? path}) =
      RemoteStorageDownloadFailure;

  /// Error al eliminar archivo.
  const factory deleteFailure({required String message, String? path}) =
      RemoteStorageDeleteFailure;

  /// Error al obtener URL.
  const factory urlFailure({required String message, String? path}) =
      RemoteStorageUrlFailure;

  /// Error al listar archivos.
  const factory listFailure({required String message, String? bucket}) =
      RemoteStorageListFailure;

  /// Error al mover archivo.
  const factory moveFailure({
    required String message,
    String? fromPath,
    String? toPath,
  }) = RemoteStorageMoveFailure;

  /// Error al copiar archivo.
  const factory copyFailure({
    required String message,
    String? fromPath,
    String? toPath,
  }) = RemoteStorageCopyFailure;

  /// Archivo no encontrado.
  const factory fileNotFound({required String path}) =
      RemoteStorageFileNotFound;

  /// Bucket no encontrado.
  const factory bucketNotFound({required String bucket}) =
      RemoteStorageBucketNotFound;

  /// Error de permisos.
  const factory permissionDenied({required String message}) =
      RemoteStoragePermissionDenied;

  /// Error desconocido.
  const factory unknown({required String message}) = RemoteStorageUnknown;
}
