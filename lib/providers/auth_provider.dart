import 'package:ai_assistant/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      print('//////////////////////////////////////////////////////////');
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      print(password);
      print(email);
      final user = await ref.read(authServiceProvider).login(email, password);
      print('//////////////////////////////////////////////////////////');
      print(user);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString() + ' HAYLOOOOOO');
    }
  }
}

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState._({this.user, this.isLoading = false, this.error = ''});

  factory AuthState.initial() => AuthState._();
  factory AuthState.loading() => AuthState._(isLoading: true);
  factory AuthState.authenticated(UserModel user) => AuthState._(user: user);
  factory AuthState.error(String message) => AuthState._(error: message);
}
