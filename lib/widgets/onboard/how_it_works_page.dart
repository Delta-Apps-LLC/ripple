import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    const howItWorks =
        "Every day, ripple will track the transactions from your connected bank account and round up that transaction to the nearest dollar.\n\n To minimize payment processing fees, ripple will withdraw that \$5 roundup from your bank and donate it to the charity you have selected once your roundups exceed the minimum donation threshold of \$5.\n\nIn your account settings, you can change the threshold, roundup, and monthly cap.";
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Text(
              howItWorks,
              style: GoogleFonts.lato(color: AppColors.black, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
