import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/themes.dart';

String getCharityLogoAsset(CharityLogo logo) => switch (logo) {
      CharityLogo.stJude => 'assets/images/charities/st_jude_logo.png',
      CharityLogo.feedingAmerica =>
        'assets/images/charities/feeding_america_logo.png',
      CharityLogo.our => 'assets/images/charities/our_logo.png',
      CharityLogo.salvationArmy =>
        'assets/images/charities/salvation_army_logo.png',
      CharityLogo.americanCancerSociety =>
        'assets/images/charities/am_cancer_society_logo.png',
    };

String getCharityCause(CharityCause cause) => switch (cause) {
      CharityCause.agriculture => 'Agriculture',
      CharityCause.health => 'Health',
      CharityCause.humanitarian => 'Humanitarian',
      CharityCause.trafficking => 'Trafficking',
      CharityCause.other => 'Other',
    };

void showCharityDetails(BuildContext context, Charity charity) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  getCharityLogoAsset(charity.logo),
                  width: 250,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  charity.charityName,
                  style: GoogleFonts.montserrat(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Cause: ${getCharityCause(charity.cause)}',
                  style: GoogleFonts.montserrat(
                    color: AppColors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  charity.charityDescription,
                  style: GoogleFonts.lato(color: AppColors.black, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.montserrat(
                        color: AppColors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
