class RoundupSetting {
  final int? id;
  final int userId;
  final int charityId;
  final int? monthlyCap;
  final double? totalYtd;
  final double? runningTotal;
  final int? donationThreshold;
  final int? roundupAmount;
  final bool isActive;

  RoundupSetting({
    this.id,
    required this.userId,
    required this.charityId,
    this.monthlyCap,
    this.totalYtd,
    this.runningTotal,
    this.donationThreshold,
    this.roundupAmount,
    required this.isActive,
  });
}
