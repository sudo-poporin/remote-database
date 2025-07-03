// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_database_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteDatabaseExceptions {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteDatabaseExceptions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RemoteDatabaseExceptions()';
}


}

/// @nodoc
class $RemoteDatabaseExceptionsCopyWith<$Res>  {
$RemoteDatabaseExceptionsCopyWith(RemoteDatabaseExceptions _, $Res Function(RemoteDatabaseExceptions) __);
}


/// Adds pattern-matching-related methods to [RemoteDatabaseExceptions].
extension RemoteDatabaseExceptionsPatterns on RemoteDatabaseExceptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _RemoteDatabaseInsertFailure value)?  insertFailure,TResult Function( _RemoteDatabaseUpdateFailure value)?  updateFailure,TResult Function( _RemoteDatabaseUpsertFailure value)?  upsertFailure,TResult Function( _RemoteDatabaseDeleteFailure value)?  deleteFailure,TResult Function( _RemoteDatabaseSelectFailure value)?  selectFailure,TResult Function( _RemoteDatabaseSelectSingleFailure value)?  selectSingleFailure,TResult Function( RemoteDatabaseNoDataFound value)?  noDataFound,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure() when insertFailure != null:
return insertFailure(_that);case _RemoteDatabaseUpdateFailure() when updateFailure != null:
return updateFailure(_that);case _RemoteDatabaseUpsertFailure() when upsertFailure != null:
return upsertFailure(_that);case _RemoteDatabaseDeleteFailure() when deleteFailure != null:
return deleteFailure(_that);case _RemoteDatabaseSelectFailure() when selectFailure != null:
return selectFailure(_that);case _RemoteDatabaseSelectSingleFailure() when selectSingleFailure != null:
return selectSingleFailure(_that);case RemoteDatabaseNoDataFound() when noDataFound != null:
return noDataFound(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _RemoteDatabaseInsertFailure value)  insertFailure,required TResult Function( _RemoteDatabaseUpdateFailure value)  updateFailure,required TResult Function( _RemoteDatabaseUpsertFailure value)  upsertFailure,required TResult Function( _RemoteDatabaseDeleteFailure value)  deleteFailure,required TResult Function( _RemoteDatabaseSelectFailure value)  selectFailure,required TResult Function( _RemoteDatabaseSelectSingleFailure value)  selectSingleFailure,required TResult Function( RemoteDatabaseNoDataFound value)  noDataFound,}){
final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure():
return insertFailure(_that);case _RemoteDatabaseUpdateFailure():
return updateFailure(_that);case _RemoteDatabaseUpsertFailure():
return upsertFailure(_that);case _RemoteDatabaseDeleteFailure():
return deleteFailure(_that);case _RemoteDatabaseSelectFailure():
return selectFailure(_that);case _RemoteDatabaseSelectSingleFailure():
return selectSingleFailure(_that);case RemoteDatabaseNoDataFound():
return noDataFound(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _RemoteDatabaseInsertFailure value)?  insertFailure,TResult? Function( _RemoteDatabaseUpdateFailure value)?  updateFailure,TResult? Function( _RemoteDatabaseUpsertFailure value)?  upsertFailure,TResult? Function( _RemoteDatabaseDeleteFailure value)?  deleteFailure,TResult? Function( _RemoteDatabaseSelectFailure value)?  selectFailure,TResult? Function( _RemoteDatabaseSelectSingleFailure value)?  selectSingleFailure,TResult? Function( RemoteDatabaseNoDataFound value)?  noDataFound,}){
final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure() when insertFailure != null:
return insertFailure(_that);case _RemoteDatabaseUpdateFailure() when updateFailure != null:
return updateFailure(_that);case _RemoteDatabaseUpsertFailure() when upsertFailure != null:
return upsertFailure(_that);case _RemoteDatabaseDeleteFailure() when deleteFailure != null:
return deleteFailure(_that);case _RemoteDatabaseSelectFailure() when selectFailure != null:
return selectFailure(_that);case _RemoteDatabaseSelectSingleFailure() when selectSingleFailure != null:
return selectSingleFailure(_that);case RemoteDatabaseNoDataFound() when noDataFound != null:
return noDataFound(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( dynamic error)?  insertFailure,TResult Function( dynamic error)?  updateFailure,TResult Function( dynamic error)?  upsertFailure,TResult Function( dynamic error)?  deleteFailure,TResult Function( dynamic error)?  selectFailure,TResult Function( dynamic error)?  selectSingleFailure,TResult Function()?  noDataFound,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure() when insertFailure != null:
return insertFailure(_that.error);case _RemoteDatabaseUpdateFailure() when updateFailure != null:
return updateFailure(_that.error);case _RemoteDatabaseUpsertFailure() when upsertFailure != null:
return upsertFailure(_that.error);case _RemoteDatabaseDeleteFailure() when deleteFailure != null:
return deleteFailure(_that.error);case _RemoteDatabaseSelectFailure() when selectFailure != null:
return selectFailure(_that.error);case _RemoteDatabaseSelectSingleFailure() when selectSingleFailure != null:
return selectSingleFailure(_that.error);case RemoteDatabaseNoDataFound() when noDataFound != null:
return noDataFound();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( dynamic error)  insertFailure,required TResult Function( dynamic error)  updateFailure,required TResult Function( dynamic error)  upsertFailure,required TResult Function( dynamic error)  deleteFailure,required TResult Function( dynamic error)  selectFailure,required TResult Function( dynamic error)  selectSingleFailure,required TResult Function()  noDataFound,}) {final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure():
return insertFailure(_that.error);case _RemoteDatabaseUpdateFailure():
return updateFailure(_that.error);case _RemoteDatabaseUpsertFailure():
return upsertFailure(_that.error);case _RemoteDatabaseDeleteFailure():
return deleteFailure(_that.error);case _RemoteDatabaseSelectFailure():
return selectFailure(_that.error);case _RemoteDatabaseSelectSingleFailure():
return selectSingleFailure(_that.error);case RemoteDatabaseNoDataFound():
return noDataFound();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( dynamic error)?  insertFailure,TResult? Function( dynamic error)?  updateFailure,TResult? Function( dynamic error)?  upsertFailure,TResult? Function( dynamic error)?  deleteFailure,TResult? Function( dynamic error)?  selectFailure,TResult? Function( dynamic error)?  selectSingleFailure,TResult? Function()?  noDataFound,}) {final _that = this;
switch (_that) {
case _RemoteDatabaseInsertFailure() when insertFailure != null:
return insertFailure(_that.error);case _RemoteDatabaseUpdateFailure() when updateFailure != null:
return updateFailure(_that.error);case _RemoteDatabaseUpsertFailure() when upsertFailure != null:
return upsertFailure(_that.error);case _RemoteDatabaseDeleteFailure() when deleteFailure != null:
return deleteFailure(_that.error);case _RemoteDatabaseSelectFailure() when selectFailure != null:
return selectFailure(_that.error);case _RemoteDatabaseSelectSingleFailure() when selectSingleFailure != null:
return selectSingleFailure(_that.error);case RemoteDatabaseNoDataFound() when noDataFound != null:
return noDataFound();case _:
  return null;

}
}

}

/// @nodoc


class _RemoteDatabaseInsertFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseInsertFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseInsertFailureCopyWith<_RemoteDatabaseInsertFailure> get copyWith => __$RemoteDatabaseInsertFailureCopyWithImpl<_RemoteDatabaseInsertFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseInsertFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.insertFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseInsertFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseInsertFailureCopyWith(_RemoteDatabaseInsertFailure value, $Res Function(_RemoteDatabaseInsertFailure) _then) = __$RemoteDatabaseInsertFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseInsertFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseInsertFailureCopyWith<$Res> {
  __$RemoteDatabaseInsertFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseInsertFailure _self;
  final $Res Function(_RemoteDatabaseInsertFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseInsertFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _RemoteDatabaseUpdateFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseUpdateFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseUpdateFailureCopyWith<_RemoteDatabaseUpdateFailure> get copyWith => __$RemoteDatabaseUpdateFailureCopyWithImpl<_RemoteDatabaseUpdateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseUpdateFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.updateFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseUpdateFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseUpdateFailureCopyWith(_RemoteDatabaseUpdateFailure value, $Res Function(_RemoteDatabaseUpdateFailure) _then) = __$RemoteDatabaseUpdateFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseUpdateFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseUpdateFailureCopyWith<$Res> {
  __$RemoteDatabaseUpdateFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseUpdateFailure _self;
  final $Res Function(_RemoteDatabaseUpdateFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseUpdateFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _RemoteDatabaseUpsertFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseUpsertFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseUpsertFailureCopyWith<_RemoteDatabaseUpsertFailure> get copyWith => __$RemoteDatabaseUpsertFailureCopyWithImpl<_RemoteDatabaseUpsertFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseUpsertFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.upsertFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseUpsertFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseUpsertFailureCopyWith(_RemoteDatabaseUpsertFailure value, $Res Function(_RemoteDatabaseUpsertFailure) _then) = __$RemoteDatabaseUpsertFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseUpsertFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseUpsertFailureCopyWith<$Res> {
  __$RemoteDatabaseUpsertFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseUpsertFailure _self;
  final $Res Function(_RemoteDatabaseUpsertFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseUpsertFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _RemoteDatabaseDeleteFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseDeleteFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseDeleteFailureCopyWith<_RemoteDatabaseDeleteFailure> get copyWith => __$RemoteDatabaseDeleteFailureCopyWithImpl<_RemoteDatabaseDeleteFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseDeleteFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.deleteFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseDeleteFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseDeleteFailureCopyWith(_RemoteDatabaseDeleteFailure value, $Res Function(_RemoteDatabaseDeleteFailure) _then) = __$RemoteDatabaseDeleteFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseDeleteFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseDeleteFailureCopyWith<$Res> {
  __$RemoteDatabaseDeleteFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseDeleteFailure _self;
  final $Res Function(_RemoteDatabaseDeleteFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseDeleteFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _RemoteDatabaseSelectFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseSelectFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseSelectFailureCopyWith<_RemoteDatabaseSelectFailure> get copyWith => __$RemoteDatabaseSelectFailureCopyWithImpl<_RemoteDatabaseSelectFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseSelectFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.selectFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseSelectFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseSelectFailureCopyWith(_RemoteDatabaseSelectFailure value, $Res Function(_RemoteDatabaseSelectFailure) _then) = __$RemoteDatabaseSelectFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseSelectFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseSelectFailureCopyWith<$Res> {
  __$RemoteDatabaseSelectFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseSelectFailure _self;
  final $Res Function(_RemoteDatabaseSelectFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseSelectFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _RemoteDatabaseSelectSingleFailure implements RemoteDatabaseExceptions {
  const _RemoteDatabaseSelectSingleFailure([this.error]);
  

 final  dynamic error;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteDatabaseSelectSingleFailureCopyWith<_RemoteDatabaseSelectSingleFailure> get copyWith => __$RemoteDatabaseSelectSingleFailureCopyWithImpl<_RemoteDatabaseSelectSingleFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteDatabaseSelectSingleFailure&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RemoteDatabaseExceptions.selectSingleFailure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteDatabaseSelectSingleFailureCopyWith<$Res> implements $RemoteDatabaseExceptionsCopyWith<$Res> {
  factory _$RemoteDatabaseSelectSingleFailureCopyWith(_RemoteDatabaseSelectSingleFailure value, $Res Function(_RemoteDatabaseSelectSingleFailure) _then) = __$RemoteDatabaseSelectSingleFailureCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class __$RemoteDatabaseSelectSingleFailureCopyWithImpl<$Res>
    implements _$RemoteDatabaseSelectSingleFailureCopyWith<$Res> {
  __$RemoteDatabaseSelectSingleFailureCopyWithImpl(this._self, this._then);

  final _RemoteDatabaseSelectSingleFailure _self;
  final $Res Function(_RemoteDatabaseSelectSingleFailure) _then;

/// Create a copy of RemoteDatabaseExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_RemoteDatabaseSelectSingleFailure(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class RemoteDatabaseNoDataFound implements RemoteDatabaseExceptions {
  const RemoteDatabaseNoDataFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteDatabaseNoDataFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RemoteDatabaseExceptions.noDataFound()';
}


}




// dart format on
