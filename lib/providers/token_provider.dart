import 'package:flutter_riverpod/flutter_riverpod.dart';
final tokenProvider = StateNotifierProvider<TokenNotifier, String>((ref) {
  return TokenNotifier();
});



class TokenNotifier extends StateNotifier<String> {
  TokenNotifier() : super('');

  String get token => state;  

  set token(String newToken) {
    state = newToken;  
  }
}