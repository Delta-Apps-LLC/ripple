enum CharityLogo {
  our,
  feedingAmerica,
  salvationArmy,
  stJude,
  americanCancerSociety,
}

enum CharityCause {
  agriculture,
  trafficking,
  health,
  humanitarian,
  other,
}

class Charity {
  final int? id;
  final String charityName;
  final String charityDescription;
  final CharityLogo logo;
  final bool isActive;
  final CharityCause cause;
  final String? stripeAccountId;

  Charity({
    this.id,
    required this.charityName,
    required this.charityDescription,
    required this.logo,
    required this.isActive,
    required this.cause,
    this.stripeAccountId,
  });
}
