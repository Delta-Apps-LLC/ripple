import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/services/charity_service.dart';

class CharityProvider with ChangeNotifier {
  CharityProvider(this._roundupSettingProvider, this._charityService) {
    log("CharityProvider created");
    refresh();
  }

  RoundupSettingProvider _roundupSettingProvider;
  final CharityService _charityService;

  List<Charity> _charities = [];
  List<Charity> get charities => _charities;
  bool _isLoadingCharities = false;
  bool get isLoadingCharities => _isLoadingCharities;

  Charity get currentCharity => _charities.firstWhere(
      (c) => c.id == _roundupSettingProvider.roundupSetting?.currentCharityId);

  Future<void> refresh() async {
    _isLoadingCharities = true;
    _charities = await _charityService.getCharities();
    _isLoadingCharities = false;
    notifyListeners();
    log("CharityProvider refreshed!");
  }

  void updateDependencies(RoundupSettingProvider roundupSettingProvider) {
    _roundupSettingProvider = roundupSettingProvider;
    refresh();
  }
}
