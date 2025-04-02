import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

Widget getAppBarTitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/ripple-logo-sm.png',
        width: 22,
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 28,
          width: 1.25,
          color: AppColors.black.withOpacity(0.3),
        ),
      ),
      Text(
        'ripple',
        style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 25),
      )
    ],
  );
}
