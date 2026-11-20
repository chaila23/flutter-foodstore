part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  // Perbaikan: Menambahkan kurung kurawal {} pada parameter required
  const factory AuthState.registerSuccess({required String message}) = _RegisterSuccess;
  const factory AuthState.failure({required String error}) = _Failure;
  const factory AuthState.registerFailure({required Map<String, dynamic> errors}) = _RegisterFailure;
}