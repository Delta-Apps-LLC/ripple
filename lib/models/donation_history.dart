abstract class DonationHistory {
  final int id;
  final int charityId;
  final int userId;
  final double donationAmount;
  final DateTime donationDate;

  DonationHistory({
    required this.id,
    required this.charityId,
    required this.userId,
    required this.donationAmount,
    required this.donationDate,
  });
}
