import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/charity_modal.dart';

class CharityListItem extends StatelessWidget {
  final Charity charity;
  final bool isSelected;
  final VoidCallback onTap;

  const CharityListItem({
    super.key,
    required this.charity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.lightBlue : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.lightGray.withOpacity(0.4),
                radius: 30,
                child: Image.asset(
                  getCharityLogoAsset(charity.logo),
                  height: 50,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      charity.charityName,
                      style: GoogleFonts.montserrat(
                          color: AppColors.black, fontSize: 18),
                    ),
                    Text(
                      'Cause: ${getCharityCause(charity.cause)}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          color: AppColors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.green,
                  size: 30,
                ),
                onPressed: () => showCharityDetails(context, charity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
