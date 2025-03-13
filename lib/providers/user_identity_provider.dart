import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/services/user_identity_service.dart';

class UserIdentityProvider with ChangeNotifier {
  UserIdentityProvider(this._authProvider, this._userIdentityService) {
    log("UserProvider created");
    refresh();
  }

  AuthProvider _authProvider;
  final UserIdentityService _userIdentityService;

  Person? _person;
  Person? get person => _person;

  bool _loadingUser = false;
  bool get loadingUser => _loadingUser;

  Future<Person?> addPerson(Person person) async {
    final res = await _userIdentityService.insertPerson(person);
    _person = res;
    notifyListeners();
    return res;
  }

  Future<void> updatePerson(Person person) async {
    final res = await _userIdentityService.updatePerson(person);
    _person = res;
    notifyListeners();
  }

  Future<void> refresh() async {
    _loadingUser = true;
    if (_authProvider.user?.email != null) {
      _person =
          await _userIdentityService.getPersonInfo(_authProvider.user!.email!);
    }
    _loadingUser = false;
    notifyListeners();
    log("UserProvider refreshed!");
  }

  void updateDependencies(AuthProvider authProvider) {
    _authProvider = authProvider;
    refresh();
  }
}
