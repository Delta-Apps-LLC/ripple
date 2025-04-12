import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

void showCustomSnackbar(
    BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: GoogleFonts.lato(color: AppColors.white, fontSize: 16),
    ),
    duration: const Duration(seconds: 4),
    backgroundColor: backgroundColor,
  ));
}
