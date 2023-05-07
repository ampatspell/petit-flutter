// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FirebaseServicesData {
  FirebaseApp get app => throw _privateConstructorUsedError;
  FirebaseFirestore get firestore => throw _privateConstructorUsedError;
  FirebaseAuth get auth => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FirebaseServicesDataCopyWith<FirebaseServicesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseServicesDataCopyWith<$Res> {
  factory $FirebaseServicesDataCopyWith(FirebaseServicesData value,
          $Res Function(FirebaseServicesData) then) =
      _$FirebaseServicesDataCopyWithImpl<$Res, FirebaseServicesData>;
  @useResult
  $Res call({FirebaseApp app, FirebaseFirestore firestore, FirebaseAuth auth});
}

/// @nodoc
class _$FirebaseServicesDataCopyWithImpl<$Res,
        $Val extends FirebaseServicesData>
    implements $FirebaseServicesDataCopyWith<$Res> {
  _$FirebaseServicesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = null,
    Object? firestore = null,
    Object? auth = null,
  }) {
    return _then(_value.copyWith(
      app: null == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as FirebaseApp,
      firestore: null == firestore
          ? _value.firestore
          : firestore // ignore: cast_nullable_to_non_nullable
              as FirebaseFirestore,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as FirebaseAuth,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirebaseServicesCopyWith<$Res>
    implements $FirebaseServicesDataCopyWith<$Res> {
  factory _$$_FirebaseServicesCopyWith(
          _$_FirebaseServices value, $Res Function(_$_FirebaseServices) then) =
      __$$_FirebaseServicesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FirebaseApp app, FirebaseFirestore firestore, FirebaseAuth auth});
}

/// @nodoc
class __$$_FirebaseServicesCopyWithImpl<$Res>
    extends _$FirebaseServicesDataCopyWithImpl<$Res, _$_FirebaseServices>
    implements _$$_FirebaseServicesCopyWith<$Res> {
  __$$_FirebaseServicesCopyWithImpl(
      _$_FirebaseServices _value, $Res Function(_$_FirebaseServices) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = null,
    Object? firestore = null,
    Object? auth = null,
  }) {
    return _then(_$_FirebaseServices(
      app: null == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as FirebaseApp,
      firestore: null == firestore
          ? _value.firestore
          : firestore // ignore: cast_nullable_to_non_nullable
              as FirebaseFirestore,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as FirebaseAuth,
    ));
  }
}

/// @nodoc

class _$_FirebaseServices implements _FirebaseServices {
  const _$_FirebaseServices(
      {required this.app, required this.firestore, required this.auth});

  @override
  final FirebaseApp app;
  @override
  final FirebaseFirestore firestore;
  @override
  final FirebaseAuth auth;

  @override
  String toString() {
    return 'FirebaseServicesData(app: $app, firestore: $firestore, auth: $auth)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirebaseServices &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.firestore, firestore) ||
                other.firestore == firestore) &&
            (identical(other.auth, auth) || other.auth == auth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, app, firestore, auth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirebaseServicesCopyWith<_$_FirebaseServices> get copyWith =>
      __$$_FirebaseServicesCopyWithImpl<_$_FirebaseServices>(this, _$identity);
}

abstract class _FirebaseServices implements FirebaseServicesData {
  const factory _FirebaseServices(
      {required final FirebaseApp app,
      required final FirebaseFirestore firestore,
      required final FirebaseAuth auth}) = _$_FirebaseServices;

  @override
  FirebaseApp get app;
  @override
  FirebaseFirestore get firestore;
  @override
  FirebaseAuth get auth;
  @override
  @JsonKey(ignore: true)
  _$$_FirebaseServicesCopyWith<_$_FirebaseServices> get copyWith =>
      throw _privateConstructorUsedError;
}
