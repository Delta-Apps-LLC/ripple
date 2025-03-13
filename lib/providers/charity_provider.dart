import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/services/charity_service.dart';

class CharityProvider with ChangeNotifier {
  CharityProvider(this._charityService) {
    log("CharityProvider created");
    refresh();
  }

  final CharityService _charityService;

  List<Charity> _charities = [];
  List<Charity> get charities => _charities;
  bool _isLoadingCharities = false;
  bool get isLoadingCharities => _isLoadingCharities;

  Future<void> refresh() async {
    _isLoadingCharities = true;
    _charities = await _charityService.getCharities();
    _isLoadingCharities = false;
    notifyListeners();
    log("CharityProvider refreshed!");
  }
}
