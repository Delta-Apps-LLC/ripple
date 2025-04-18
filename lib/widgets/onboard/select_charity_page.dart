import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/lists/charity_list.dart';

class SelectCharityPage extends StatelessWidget {
  const SelectCharityPage({super.key, required this.onCharitySelected});
  final Function(Charity?) onCharitySelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        children: [
          Text(
            'Your round-ups will be donated to the charity you select here.\n\nYou can add or remove charities from your rotation at any time later.',
            style: GoogleFonts.lato(color: AppColors.black, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          CharityList(
            onCharitySelected: onCharitySelected,
          )
        ],
      ),
    );
  }
}
