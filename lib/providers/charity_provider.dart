import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/models/roundup_setting.dart';
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

  Charity? _nextCharity;
  Charity? get nextCharity => _nextCharity;

  List<Charity> _charityQueue = [];
  List<Charity> get charityQueue => _charityQueue;

  bool _hasQueueBeenModified = false;
  bool get hasQueueBeenModified => _hasQueueBeenModified;

  void addToQueue(Charity charity) {
    _charityQueue.add(charity);
    _hasQueueBeenModified = true;
    notifyListeners();
  }

  void removeFromQueue(Charity charity) {
    _charityQueue.removeWhere((c) => c.id == charity.id);
    _hasQueueBeenModified = true;
    notifyListeners();
  }

  Future<void> saveQueueEdits() async {
    await _charityService.saveQueueEdits(
        _roundupSettingProvider.roundupSetting!.userId, _charityQueue);
    if (_roundupSettingProvider.roundupSetting!.nextCharityIndex! >=
        _charityQueue.length - 1) {
      await _roundupSettingProvider.resetNextCharityIndex();
    }
    _hasQueueBeenModified = false;
    refresh();
  }

  Future<Exception?> insertFirstUserCharity(
      int charityId, RoundupSetting setting) async {
    final response =
        await _charityService.insertFirstUserCharity(charityId, setting.userId);
    if (response.isNotEmpty) {
      await _roundupSettingProvider.insertRoundupSetting(setting);
    } else {
      return Exception();
    }
    return null;
  }

  Future<void> refresh() async {
    _isLoadingCharities = true;
    _charities = await _charityService.getCharities();
    _charityQueue = await _charityService
        .getCharityQueue(_roundupSettingProvider.roundupSetting?.userId ?? 0);
    if (_charityQueue.isNotEmpty) {
      _nextCharity = _charityQueue[
          _roundupSettingProvider.roundupSetting?.nextCharityIndex ?? 0];
    }
    _isLoadingCharities = false;
    notifyListeners();
    log("CharityProvider refreshed!");
  }

  void updateDependencies(RoundupSettingProvider roundupSettingProvider) {
    _roundupSettingProvider = roundupSettingProvider;
    refresh();
  }
}
