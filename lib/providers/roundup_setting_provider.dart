import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/roundup_setting.dart';
import 'package:ripple/services/roundup_setting_service.dart';

class RoundupSettingProvider with ChangeNotifier {
  RoundupSettingProvider(this._roundupSettingService) {
    log('RoundupSettingProvider created');
    refresh();
  }

  final RoundupSettingService _roundupSettingService;

  RoundupSetting? _roundupSetting;
  RoundupSetting? get roundupSetting => _roundupSetting;

  Future<void> setRoundupSetting(RoundupSetting setting) async {
    final res = _roundupSetting?.id == null
        ? await _roundupSettingService.insertRoundupSettings(setting)
        : await _roundupSettingService.updateRoundupSettings(setting);
    _roundupSetting = res;
    notifyListeners();
  }

  Future<void> refresh() async {
    _roundupSetting = await _roundupSettingService.getRoundupSettings();
    notifyListeners();
    log('RoundupSettingProvider refreshed!');
  }
}
