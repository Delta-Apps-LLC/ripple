import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/parse_charity_info.dart';
import 'package:ripple/widgets/misc/page_title.dart';

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
                PageTitle(title: charity.charityName),
                Text(
                  'Cause: ${getCharityCause(charity.cause)}',
                  style: GoogleFonts.montserrat(
                    color: AppColors.black,
                    fontSize: 18,
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
