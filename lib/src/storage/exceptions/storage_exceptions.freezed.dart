// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteStorageException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RemoteStorageException()';
}


}

/// @nodoc
class $RemoteStorageExceptionCopyWith<$Res>  {
$RemoteStorageExceptionCopyWith(RemoteStorageException _, $Res Function(RemoteStorageException) __);
}


/// Adds pattern-matching-related methods to [RemoteStorageException].
extension RemoteStorageExceptionPatterns on RemoteStorageException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RemoteStorageUploadFailure value)?  uploadFailure,TResult Function( RemoteStorageDownloadFailure value)?  downloadFailure,TResult Function( RemoteStorageDeleteFailure value)?  deleteFailure,TResult Function( RemoteStorageUrlFailure value)?  urlFailure,TResult Function( RemoteStorageListFailure value)?  listFailure,TResult Function( RemoteStorageMoveFailure value)?  moveFailure,TResult Function( RemoteStorageFileNotFound value)?  fileNotFound,TResult Function( RemoteStorageBucketNotFound value)?  bucketNotFound,TResult Function( RemoteStoragePermissionDenied value)?  permissionDenied,TResult Function( RemoteStorageUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RemoteStorageUploadFailure() when uploadFailure != null:
return uploadFailure(_that);case RemoteStorageDownloadFailure() when downloadFailure != null:
return downloadFailure(_that);case RemoteStorageDeleteFailure() when deleteFailure != null:
return deleteFailure(_that);case RemoteStorageUrlFailure() when urlFailure != null:
return urlFailure(_that);case RemoteStorageListFailure() when listFailure != null:
return listFailure(_that);case RemoteStorageMoveFailure() when moveFailure != null:
return moveFailure(_that);case RemoteStorageFileNotFound() when fileNotFound != null:
return fileNotFound(_that);case RemoteStorageBucketNotFound() when bucketNotFound != null:
return bucketNotFound(_that);case RemoteStoragePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case RemoteStorageUnknown() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RemoteStorageUploadFailure value)  uploadFailure,required TResult Function( RemoteStorageDownloadFailure value)  downloadFailure,required TResult Function( RemoteStorageDeleteFailure value)  deleteFailure,required TResult Function( RemoteStorageUrlFailure value)  urlFailure,required TResult Function( RemoteStorageListFailure value)  listFailure,required TResult Function( RemoteStorageMoveFailure value)  moveFailure,required TResult Function( RemoteStorageFileNotFound value)  fileNotFound,required TResult Function( RemoteStorageBucketNotFound value)  bucketNotFound,required TResult Function( RemoteStoragePermissionDenied value)  permissionDenied,required TResult Function( RemoteStorageUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case RemoteStorageUploadFailure():
return uploadFailure(_that);case RemoteStorageDownloadFailure():
return downloadFailure(_that);case RemoteStorageDeleteFailure():
return deleteFailure(_that);case RemoteStorageUrlFailure():
return urlFailure(_that);case RemoteStorageListFailure():
return listFailure(_that);case RemoteStorageMoveFailure():
return moveFailure(_that);case RemoteStorageFileNotFound():
return fileNotFound(_that);case RemoteStorageBucketNotFound():
return bucketNotFound(_that);case RemoteStoragePermissionDenied():
return permissionDenied(_that);case RemoteStorageUnknown():
return unknown(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RemoteStorageUploadFailure value)?  uploadFailure,TResult? Function( RemoteStorageDownloadFailure value)?  downloadFailure,TResult? Function( RemoteStorageDeleteFailure value)?  deleteFailure,TResult? Function( RemoteStorageUrlFailure value)?  urlFailure,TResult? Function( RemoteStorageListFailure value)?  listFailure,TResult? Function( RemoteStorageMoveFailure value)?  moveFailure,TResult? Function( RemoteStorageFileNotFound value)?  fileNotFound,TResult? Function( RemoteStorageBucketNotFound value)?  bucketNotFound,TResult? Function( RemoteStoragePermissionDenied value)?  permissionDenied,TResult? Function( RemoteStorageUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case RemoteStorageUploadFailure() when uploadFailure != null:
return uploadFailure(_that);case RemoteStorageDownloadFailure() when downloadFailure != null:
return downloadFailure(_that);case RemoteStorageDeleteFailure() when deleteFailure != null:
return deleteFailure(_that);case RemoteStorageUrlFailure() when urlFailure != null:
return urlFailure(_that);case RemoteStorageListFailure() when listFailure != null:
return listFailure(_that);case RemoteStorageMoveFailure() when moveFailure != null:
return moveFailure(_that);case RemoteStorageFileNotFound() when fileNotFound != null:
return fileNotFound(_that);case RemoteStorageBucketNotFound() when bucketNotFound != null:
return bucketNotFound(_that);case RemoteStoragePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case RemoteStorageUnknown() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? path)?  uploadFailure,TResult Function( String message,  String? path)?  downloadFailure,TResult Function( String message,  String? path)?  deleteFailure,TResult Function( String message,  String? path)?  urlFailure,TResult Function( String message,  String? bucket)?  listFailure,TResult Function( String message,  String? fromPath,  String? toPath)?  moveFailure,TResult Function( String path)?  fileNotFound,TResult Function( String bucket)?  bucketNotFound,TResult Function( String message)?  permissionDenied,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RemoteStorageUploadFailure() when uploadFailure != null:
return uploadFailure(_that.message,_that.path);case RemoteStorageDownloadFailure() when downloadFailure != null:
return downloadFailure(_that.message,_that.path);case RemoteStorageDeleteFailure() when deleteFailure != null:
return deleteFailure(_that.message,_that.path);case RemoteStorageUrlFailure() when urlFailure != null:
return urlFailure(_that.message,_that.path);case RemoteStorageListFailure() when listFailure != null:
return listFailure(_that.message,_that.bucket);case RemoteStorageMoveFailure() when moveFailure != null:
return moveFailure(_that.message,_that.fromPath,_that.toPath);case RemoteStorageFileNotFound() when fileNotFound != null:
return fileNotFound(_that.path);case RemoteStorageBucketNotFound() when bucketNotFound != null:
return bucketNotFound(_that.bucket);case RemoteStoragePermissionDenied() when permissionDenied != null:
return permissionDenied(_that.message);case RemoteStorageUnknown() when unknown != null:
return unknown(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? path)  uploadFailure,required TResult Function( String message,  String? path)  downloadFailure,required TResult Function( String message,  String? path)  deleteFailure,required TResult Function( String message,  String? path)  urlFailure,required TResult Function( String message,  String? bucket)  listFailure,required TResult Function( String message,  String? fromPath,  String? toPath)  moveFailure,required TResult Function( String path)  fileNotFound,required TResult Function( String bucket)  bucketNotFound,required TResult Function( String message)  permissionDenied,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case RemoteStorageUploadFailure():
return uploadFailure(_that.message,_that.path);case RemoteStorageDownloadFailure():
return downloadFailure(_that.message,_that.path);case RemoteStorageDeleteFailure():
return deleteFailure(_that.message,_that.path);case RemoteStorageUrlFailure():
return urlFailure(_that.message,_that.path);case RemoteStorageListFailure():
return listFailure(_that.message,_that.bucket);case RemoteStorageMoveFailure():
return moveFailure(_that.message,_that.fromPath,_that.toPath);case RemoteStorageFileNotFound():
return fileNotFound(_that.path);case RemoteStorageBucketNotFound():
return bucketNotFound(_that.bucket);case RemoteStoragePermissionDenied():
return permissionDenied(_that.message);case RemoteStorageUnknown():
return unknown(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? path)?  uploadFailure,TResult? Function( String message,  String? path)?  downloadFailure,TResult? Function( String message,  String? path)?  deleteFailure,TResult? Function( String message,  String? path)?  urlFailure,TResult? Function( String message,  String? bucket)?  listFailure,TResult? Function( String message,  String? fromPath,  String? toPath)?  moveFailure,TResult? Function( String path)?  fileNotFound,TResult? Function( String bucket)?  bucketNotFound,TResult? Function( String message)?  permissionDenied,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case RemoteStorageUploadFailure() when uploadFailure != null:
return uploadFailure(_that.message,_that.path);case RemoteStorageDownloadFailure() when downloadFailure != null:
return downloadFailure(_that.message,_that.path);case RemoteStorageDeleteFailure() when deleteFailure != null:
return deleteFailure(_that.message,_that.path);case RemoteStorageUrlFailure() when urlFailure != null:
return urlFailure(_that.message,_that.path);case RemoteStorageListFailure() when listFailure != null:
return listFailure(_that.message,_that.bucket);case RemoteStorageMoveFailure() when moveFailure != null:
return moveFailure(_that.message,_that.fromPath,_that.toPath);case RemoteStorageFileNotFound() when fileNotFound != null:
return fileNotFound(_that.path);case RemoteStorageBucketNotFound() when bucketNotFound != null:
return bucketNotFound(_that.bucket);case RemoteStoragePermissionDenied() when permissionDenied != null:
return permissionDenied(_that.message);case RemoteStorageUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class RemoteStorageUploadFailure implements RemoteStorageException {
  const RemoteStorageUploadFailure({required this.message, this.path});
  

 final  String message;
 final  String? path;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageUploadFailureCopyWith<RemoteStorageUploadFailure> get copyWith => _$RemoteStorageUploadFailureCopyWithImpl<RemoteStorageUploadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageUploadFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,message,path);

@override
String toString() {
  return 'RemoteStorageException.uploadFailure(message: $message, path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageUploadFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageUploadFailureCopyWith(RemoteStorageUploadFailure value, $Res Function(RemoteStorageUploadFailure) _then) = _$RemoteStorageUploadFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? path
});




}
/// @nodoc
class _$RemoteStorageUploadFailureCopyWithImpl<$Res>
    implements $RemoteStorageUploadFailureCopyWith<$Res> {
  _$RemoteStorageUploadFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageUploadFailure _self;
  final $Res Function(RemoteStorageUploadFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? path = freezed,}) {
  return _then(RemoteStorageUploadFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageDownloadFailure implements RemoteStorageException {
  const RemoteStorageDownloadFailure({required this.message, this.path});
  

 final  String message;
 final  String? path;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageDownloadFailureCopyWith<RemoteStorageDownloadFailure> get copyWith => _$RemoteStorageDownloadFailureCopyWithImpl<RemoteStorageDownloadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageDownloadFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,message,path);

@override
String toString() {
  return 'RemoteStorageException.downloadFailure(message: $message, path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageDownloadFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageDownloadFailureCopyWith(RemoteStorageDownloadFailure value, $Res Function(RemoteStorageDownloadFailure) _then) = _$RemoteStorageDownloadFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? path
});




}
/// @nodoc
class _$RemoteStorageDownloadFailureCopyWithImpl<$Res>
    implements $RemoteStorageDownloadFailureCopyWith<$Res> {
  _$RemoteStorageDownloadFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageDownloadFailure _self;
  final $Res Function(RemoteStorageDownloadFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? path = freezed,}) {
  return _then(RemoteStorageDownloadFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageDeleteFailure implements RemoteStorageException {
  const RemoteStorageDeleteFailure({required this.message, this.path});
  

 final  String message;
 final  String? path;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageDeleteFailureCopyWith<RemoteStorageDeleteFailure> get copyWith => _$RemoteStorageDeleteFailureCopyWithImpl<RemoteStorageDeleteFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageDeleteFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,message,path);

@override
String toString() {
  return 'RemoteStorageException.deleteFailure(message: $message, path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageDeleteFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageDeleteFailureCopyWith(RemoteStorageDeleteFailure value, $Res Function(RemoteStorageDeleteFailure) _then) = _$RemoteStorageDeleteFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? path
});




}
/// @nodoc
class _$RemoteStorageDeleteFailureCopyWithImpl<$Res>
    implements $RemoteStorageDeleteFailureCopyWith<$Res> {
  _$RemoteStorageDeleteFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageDeleteFailure _self;
  final $Res Function(RemoteStorageDeleteFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? path = freezed,}) {
  return _then(RemoteStorageDeleteFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageUrlFailure implements RemoteStorageException {
  const RemoteStorageUrlFailure({required this.message, this.path});
  

 final  String message;
 final  String? path;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageUrlFailureCopyWith<RemoteStorageUrlFailure> get copyWith => _$RemoteStorageUrlFailureCopyWithImpl<RemoteStorageUrlFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageUrlFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,message,path);

@override
String toString() {
  return 'RemoteStorageException.urlFailure(message: $message, path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageUrlFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageUrlFailureCopyWith(RemoteStorageUrlFailure value, $Res Function(RemoteStorageUrlFailure) _then) = _$RemoteStorageUrlFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? path
});




}
/// @nodoc
class _$RemoteStorageUrlFailureCopyWithImpl<$Res>
    implements $RemoteStorageUrlFailureCopyWith<$Res> {
  _$RemoteStorageUrlFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageUrlFailure _self;
  final $Res Function(RemoteStorageUrlFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? path = freezed,}) {
  return _then(RemoteStorageUrlFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageListFailure implements RemoteStorageException {
  const RemoteStorageListFailure({required this.message, this.bucket});
  

 final  String message;
 final  String? bucket;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageListFailureCopyWith<RemoteStorageListFailure> get copyWith => _$RemoteStorageListFailureCopyWithImpl<RemoteStorageListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageListFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.bucket, bucket) || other.bucket == bucket));
}


@override
int get hashCode => Object.hash(runtimeType,message,bucket);

@override
String toString() {
  return 'RemoteStorageException.listFailure(message: $message, bucket: $bucket)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageListFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageListFailureCopyWith(RemoteStorageListFailure value, $Res Function(RemoteStorageListFailure) _then) = _$RemoteStorageListFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? bucket
});




}
/// @nodoc
class _$RemoteStorageListFailureCopyWithImpl<$Res>
    implements $RemoteStorageListFailureCopyWith<$Res> {
  _$RemoteStorageListFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageListFailure _self;
  final $Res Function(RemoteStorageListFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? bucket = freezed,}) {
  return _then(RemoteStorageListFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,bucket: freezed == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageMoveFailure implements RemoteStorageException {
  const RemoteStorageMoveFailure({required this.message, this.fromPath, this.toPath});
  

 final  String message;
 final  String? fromPath;
 final  String? toPath;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageMoveFailureCopyWith<RemoteStorageMoveFailure> get copyWith => _$RemoteStorageMoveFailureCopyWithImpl<RemoteStorageMoveFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageMoveFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.fromPath, fromPath) || other.fromPath == fromPath)&&(identical(other.toPath, toPath) || other.toPath == toPath));
}


@override
int get hashCode => Object.hash(runtimeType,message,fromPath,toPath);

@override
String toString() {
  return 'RemoteStorageException.moveFailure(message: $message, fromPath: $fromPath, toPath: $toPath)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageMoveFailureCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageMoveFailureCopyWith(RemoteStorageMoveFailure value, $Res Function(RemoteStorageMoveFailure) _then) = _$RemoteStorageMoveFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? fromPath, String? toPath
});




}
/// @nodoc
class _$RemoteStorageMoveFailureCopyWithImpl<$Res>
    implements $RemoteStorageMoveFailureCopyWith<$Res> {
  _$RemoteStorageMoveFailureCopyWithImpl(this._self, this._then);

  final RemoteStorageMoveFailure _self;
  final $Res Function(RemoteStorageMoveFailure) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? fromPath = freezed,Object? toPath = freezed,}) {
  return _then(RemoteStorageMoveFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fromPath: freezed == fromPath ? _self.fromPath : fromPath // ignore: cast_nullable_to_non_nullable
as String?,toPath: freezed == toPath ? _self.toPath : toPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoteStorageFileNotFound implements RemoteStorageException {
  const RemoteStorageFileNotFound({required this.path});
  

 final  String path;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageFileNotFoundCopyWith<RemoteStorageFileNotFound> get copyWith => _$RemoteStorageFileNotFoundCopyWithImpl<RemoteStorageFileNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageFileNotFound&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'RemoteStorageException.fileNotFound(path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageFileNotFoundCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageFileNotFoundCopyWith(RemoteStorageFileNotFound value, $Res Function(RemoteStorageFileNotFound) _then) = _$RemoteStorageFileNotFoundCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$RemoteStorageFileNotFoundCopyWithImpl<$Res>
    implements $RemoteStorageFileNotFoundCopyWith<$Res> {
  _$RemoteStorageFileNotFoundCopyWithImpl(this._self, this._then);

  final RemoteStorageFileNotFound _self;
  final $Res Function(RemoteStorageFileNotFound) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(RemoteStorageFileNotFound(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoteStorageBucketNotFound implements RemoteStorageException {
  const RemoteStorageBucketNotFound({required this.bucket});
  

 final  String bucket;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageBucketNotFoundCopyWith<RemoteStorageBucketNotFound> get copyWith => _$RemoteStorageBucketNotFoundCopyWithImpl<RemoteStorageBucketNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageBucketNotFound&&(identical(other.bucket, bucket) || other.bucket == bucket));
}


@override
int get hashCode => Object.hash(runtimeType,bucket);

@override
String toString() {
  return 'RemoteStorageException.bucketNotFound(bucket: $bucket)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageBucketNotFoundCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageBucketNotFoundCopyWith(RemoteStorageBucketNotFound value, $Res Function(RemoteStorageBucketNotFound) _then) = _$RemoteStorageBucketNotFoundCopyWithImpl;
@useResult
$Res call({
 String bucket
});




}
/// @nodoc
class _$RemoteStorageBucketNotFoundCopyWithImpl<$Res>
    implements $RemoteStorageBucketNotFoundCopyWith<$Res> {
  _$RemoteStorageBucketNotFoundCopyWithImpl(this._self, this._then);

  final RemoteStorageBucketNotFound _self;
  final $Res Function(RemoteStorageBucketNotFound) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bucket = null,}) {
  return _then(RemoteStorageBucketNotFound(
bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoteStoragePermissionDenied implements RemoteStorageException {
  const RemoteStoragePermissionDenied({required this.message});
  

 final  String message;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStoragePermissionDeniedCopyWith<RemoteStoragePermissionDenied> get copyWith => _$RemoteStoragePermissionDeniedCopyWithImpl<RemoteStoragePermissionDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStoragePermissionDenied&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RemoteStorageException.permissionDenied(message: $message)';
}


}

/// @nodoc
abstract mixin class $RemoteStoragePermissionDeniedCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStoragePermissionDeniedCopyWith(RemoteStoragePermissionDenied value, $Res Function(RemoteStoragePermissionDenied) _then) = _$RemoteStoragePermissionDeniedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RemoteStoragePermissionDeniedCopyWithImpl<$Res>
    implements $RemoteStoragePermissionDeniedCopyWith<$Res> {
  _$RemoteStoragePermissionDeniedCopyWithImpl(this._self, this._then);

  final RemoteStoragePermissionDenied _self;
  final $Res Function(RemoteStoragePermissionDenied) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RemoteStoragePermissionDenied(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoteStorageUnknown implements RemoteStorageException {
  const RemoteStorageUnknown({required this.message});
  

 final  String message;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStorageUnknownCopyWith<RemoteStorageUnknown> get copyWith => _$RemoteStorageUnknownCopyWithImpl<RemoteStorageUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteStorageUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RemoteStorageException.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $RemoteStorageUnknownCopyWith<$Res> implements $RemoteStorageExceptionCopyWith<$Res> {
  factory $RemoteStorageUnknownCopyWith(RemoteStorageUnknown value, $Res Function(RemoteStorageUnknown) _then) = _$RemoteStorageUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RemoteStorageUnknownCopyWithImpl<$Res>
    implements $RemoteStorageUnknownCopyWith<$Res> {
  _$RemoteStorageUnknownCopyWithImpl(this._self, this._then);

  final RemoteStorageUnknown _self;
  final $Res Function(RemoteStorageUnknown) _then;

/// Create a copy of RemoteStorageException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RemoteStorageUnknown(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
