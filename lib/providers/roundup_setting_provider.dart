import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/roundup_setting.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/services/roundup_setting_service.dart';

class RoundupSettingProvider with ChangeNotifier {
  RoundupSettingProvider(
      this._userIdentityProvider, this._roundupSettingService) {
    log('RoundupSettingProvider created');
    refresh();
  }

  final RoundupSettingService _roundupSettingService;
  UserIdentityProvider _userIdentityProvider;

  RoundupSetting? _roundupSetting;
  RoundupSetting? get roundupSetting => _roundupSetting;

  bool _loadingRoundupSetting = false;
  bool get loadingRoundupSetting => _loadingRoundupSetting;

  Future<void> insertRoundupSetting(RoundupSetting setting) async {
    final res = await _roundupSettingService.insertRoundupSettings(setting);
    _roundupSetting = res;
    notifyListeners();
  }

  Future<void> updateRoundupSetting(RoundupSetting setting) async {
    final res = await _roundupSettingService.updateRoundupSettings(setting);
    _roundupSetting = res;
    notifyListeners();
  }

  Future<void> resetNextCharityIndex() async {
    await _roundupSettingService.resetNextCharityIndex(_roundupSetting!.id!);
    refresh();
  }

  Future<void> refresh() async {
    _loadingRoundupSetting = true;
    _roundupSetting = await _roundupSettingService
        .getRoundupSettings(_userIdentityProvider.person?.id ?? 0);
    _loadingRoundupSetting = false;
    notifyListeners();
    log('RoundupSettingProvider refreshed!');
  }

  void updateDependencies(UserIdentityProvider userIdentityProvider) {
    _userIdentityProvider = userIdentityProvider;
    refresh();
  }
}
