import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    const howItWorks =
        "Every day, ripple will track the transactions from your connected accounts and round up those transactions to the nearest dollar.\n\nTo minimize payment processing fees, ripple waits to donate those round-ups from your bank account until your round-ups exceed the minimum donation threshold of \$5.\n\nAll round-up settings can be found and edited on the Settings page in your account.";
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
          ),
        ],
      ),
    );
  }
}
