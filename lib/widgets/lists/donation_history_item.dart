import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/models/donation_history.dart';
import 'package:ripple/themes.dart';

class DonationHistoryItem extends StatelessWidget {
  const DonationHistoryItem({super.key, required this.item});
  final DonationHistory item;

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

  String formatDate(DateTime timestamp) {
    final day = timestamp.day;
    final month = timestamp.month;
    final year = timestamp.year;
    final monthStr = switch (month) {
      1 => 'January',
      2 => 'February',
      3 => 'March',
      4 => 'April',
      5 => 'May',
      6 => 'June',
      7 => 'July',
      8 => 'August',
      9 => 'September',
      10 => 'October',
      11 => 'November',
      12 => 'December',
      _ => 'Invalid Month',
    };

    return '$monthStr $day, $year';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightGray.withOpacity(0.4),
              radius: 20,
              child: Image.asset(
                getCharityLogoAsset(item.charityLogo),
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
                    formatDate(item.donationDate),
                    style: GoogleFonts.montserrat(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    item.charityName,
                    style: GoogleFonts.montserrat(
                        color: AppColors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              '\$${item.donationAmount.toStringAsFixed(2)}',
              style: GoogleFonts.montserrat(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
