enum RoundupMode { automatic, manual, random }

class RoundupSetting {
  final int? id;
  final int userId;
  final int currentCharityId;
  final int? monthlyCap;
  final bool? hasMonthlyCap;
  final double? totalYtd;
  final double? runningTotal;
  final int? donationThreshold;
  final int? roundupAmount;
  final RoundupMode? roundupMode;
  final bool isActive;

  RoundupSetting({
    this.id,
    required this.userId,
    required this.currentCharityId,
    this.monthlyCap,
    this.hasMonthlyCap,
    this.totalYtd,
    this.runningTotal,
    this.donationThreshold,
    this.roundupAmount,
    this.roundupMode,
    required this.isActive,
  });
}
