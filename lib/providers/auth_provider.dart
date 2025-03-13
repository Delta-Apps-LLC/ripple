import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ripple/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._authService) {
    log("AuthProvider created");
    refresh();
  }

  final AuthService _authService;

  User? _user;
  User? get user => _user;

  Session? _session;
  Session? get session => _session;

  bool _loadingUser = false;
  bool get loadingUser => _loadingUser;

  Future<AuthException?> signUp(String email, String password) async {
    final res = await _authService.signUp(email, password);
    await refresh();
    return res;
  }

  Future<AuthException?> signIn(String email, String password) async {
    final res = await _authService.signIn(email, password);
    await refresh();
    return res;
  }

  Future<AuthException?> deleteAuthUser(String userId) async {
    final res = await _authService.deleteAuthUser(userId);
    await refresh();
    return res;
  }

  Future<void> logout() async {
    await _authService.logout();
    await refresh();
  }

  Future<void> refresh() async {
    _loadingUser = true;
    _user = _authService.getCurrentUser();
    _session = _authService.getCurrentSession();
    _loadingUser = false;
    notifyListeners();
    log("AuthProvider refreshed!");
  }
}
