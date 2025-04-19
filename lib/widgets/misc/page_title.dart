import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.trailingButton,
  });
  final String title;
  final String? subTitle;
  final Widget? trailingButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: trailingButton != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (trailingButton != null)
              Icon(
                Icons.refresh,
                size: 28,
                color: Colors.transparent,
              ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: AppColors.black, fontSize: 24),
                  ),
                  if (subTitle != null)
                    Text(
                      '$subTitle',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: AppColors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                ],
              ),
            ),
            if (trailingButton != null) trailingButton!
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        const Divider(),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}
