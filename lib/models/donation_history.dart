import 'package:ripple/models/charity.dart';

class DonationHistory {
  final int id;
  final int charityId;
  final String charityName;
  final CharityLogo charityLogo;
  final int userId;
  final double donationAmount;
  final DateTime donationDate;

  DonationHistory({
    required this.id,
    required this.charityId,
    required this.charityName,
    required this.charityLogo,
    required this.userId,
    required this.donationAmount,
    required this.donationDate,
  });
}
