import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/models/donation_history.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/services/donation_history_service.dart';

class DonationHistoryProvider with ChangeNotifier {
  DonationHistoryProvider(this._userIdentityProvider, this._charityProvider,
      this._donationHistoryService) {
    log('DonationHistoryProvider created');
    refresh();
  }

  UserIdentityProvider _userIdentityProvider;
  CharityProvider _charityProvider;
  final DonationHistoryService _donationHistoryService;

  List<DonationHistory> _allDonationHistory = [];
  List<DonationHistory> get allDonationHistory => _allDonationHistory;

  List<DonationHistory> _filteredDonationHistory = [];
  List<DonationHistory> get filteredDonationHistory => _filteredDonationHistory;

  List<int> _years = [];
  List<int> get years => _years;

  int? _donationYearFilter;
  int? get donationYearFilter => _donationYearFilter;

  List<Charity> _charities = [];
  List<Charity> get charities => _charities;

  Charity? _donationCharityFilter;
  Charity? get donationCharityFilter => _donationCharityFilter;

  bool _loadingHistory = false;
  bool get loadingHistory => _loadingHistory;

  Future<void> _calculateYearRange() async {
    if (_allDonationHistory.isEmpty) {
      _years = [];
      return;
    }

    Set<int> uniqueYears = {};

    for (var donation in _allDonationHistory) {
      uniqueYears.add(donation.donationDate.year);
    }

    _years = uniqueYears.toList()..sort((b, a) => a.compareTo(b));
  }

  Future<void> _calculateCharityRange() async {
    if (_allDonationHistory.isEmpty) {
      _charities = [];
      return;
    }

    Set<int> uniqueCharityIds = {};

    for (var donation in _allDonationHistory) {
      uniqueCharityIds.add(donation.charityId);
    }

    _charities = _charityProvider.charities
        .where((charity) => uniqueCharityIds.contains(charity.id))
        .toList();
  }

  Future<void> setDonationYearFilter(int? selectedYear) async {
    _donationYearFilter = selectedYear;
    _applyFilters();
    notifyListeners();
  }

  Future<void> setDonationCharityFilter(Charity? selectedCharity) async {
    _donationCharityFilter = selectedCharity;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_donationYearFilter == null && _donationCharityFilter == null) {
      _filteredDonationHistory = _allDonationHistory;
    } else {
      _filteredDonationHistory = _allDonationHistory.where((donation) {
        bool yearMatch = true;
        bool charityMatch = true;

        if (_donationYearFilter != null) {
          yearMatch = donation.donationDate.year == _donationYearFilter;
        }

        if (_donationCharityFilter != null) {
          charityMatch = donation.charityId == _donationCharityFilter!.id;
        }

        return yearMatch && charityMatch;
      }).toList();
    }
  }

  Future<void> refresh() async {
    _loadingHistory = true;
    _allDonationHistory = await _donationHistoryService
        .getDonationHistory(_userIdentityProvider.person?.id ?? 0);
    await _calculateYearRange();
    await _calculateCharityRange();
    _applyFilters();
    _loadingHistory = false;
    notifyListeners();
    log('DonationHistoryProvider refreshed!');
  }

  void updateDependencies(UserIdentityProvider userIdentityProvider,
      CharityProvider charityProvider) {
    _userIdentityProvider = userIdentityProvider;
    _charityProvider = charityProvider;
    refresh();
  }
}
