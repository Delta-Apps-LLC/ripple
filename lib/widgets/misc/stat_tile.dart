import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/stat_info_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
                      color: AppColors.black, fontSize: 22),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: AppColors.black, fontSize: 16),
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
                size: 30,
              ),
              onPressed: () => showInfoModal(context, stat, description),
            ),
          ),
        ],
      ),
    );
  }
}
