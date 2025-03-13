import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.stat,
    required this.label,
    required this.isFullWidth,
    required this.description,
  });
  final String stat;
  final String label;
  final String description;
  final bool isFullWidth;

  void showInfoModal(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      height: 150,
      width: isFullWidth
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 2, color: AppColors.purple),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stat,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: AppColors.black, fontSize: 26),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: AppColors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: AppColors.darkBlue,
                size: 35,
              ),
              onPressed: () => showInfoModal(context),
            ),
          ),
        ],
      ),
    );
  }
}
