import 'package:ripple/models/charity.dart';

String getCharityLogoAsset(CharityLogo logo) => switch (logo) {
      CharityLogo.stJude => 'assets/images/charities/st_jude_logo.png',
      CharityLogo.feedingAmerica =>
        'assets/images/charities/feeding_america_logo.png',
      CharityLogo.our => 'assets/images/charities/our_logo.png',
      CharityLogo.salvationArmy =>
        'assets/images/charities/salvation_army_logo.png',
      CharityLogo.americanCancerSociety =>
        'assets/images/charities/am_cancer_society_logo.png',
      CharityLogo.doctorsWithoutBorders => 'assets/images/charities/doctors_without_borders_logo.png',
      CharityLogo.noKidHungry => 'assets/images/charities/no_kid_hungry_logo.png',
      CharityLogo.worldWildlife => 'assets/images/charities/world_wildlife_logo.png',
    };

String getCharityCause(CharityCause cause) => switch (cause) {
      CharityCause.agriculture => 'Agriculture',
      CharityCause.health => 'Health',
      CharityCause.humanitarian => 'Humanitarian',
      CharityCause.trafficking => 'Trafficking',
      CharityCause.conservation => 'Conservation',
      CharityCause.hunger => 'Hunger',
      CharityCause.other => 'Other',
    };