import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/donation_history.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/services/donation_history_service.dart';

class DonationHistoryProvider with ChangeNotifier {
  DonationHistoryProvider(
      this._userIdentityProvider, this._donationHistoryService) {
    log('DonationHistoryProvider created');
    refresh();
  }

  UserIdentityProvider _userIdentityProvider;
  final DonationHistoryService _donationHistoryService;

  List<DonationHistory> _donationHistory = [];
  List<DonationHistory> get donationHistory => _donationHistory;

  bool _loadingHistory = false;
  bool get loadingHistory => _loadingHistory;

  Future<void> refresh() async {
    _loadingHistory = true;
    _donationHistory = await _donationHistoryService
        .getDonationHistory(_userIdentityProvider.person?.id ?? 0);
    _loadingHistory = false;
  }

  void updateDependencies(UserIdentityProvider userIdentityProvider) {
    _userIdentityProvider = userIdentityProvider;
    refresh();
  }
}
