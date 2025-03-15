import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 28),
        ),
        const Divider(),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}
