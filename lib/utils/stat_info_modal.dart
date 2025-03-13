import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

void showInfoModal(BuildContext context, String stat, String description) {
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
                  Text(
                    'What does this mean?',
                    style: GoogleFonts.lato(
                      color: AppColors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    stat,
                    style: GoogleFonts.montserrat(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style:
                        GoogleFonts.lato(color: AppColors.black, fontSize: 18),
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