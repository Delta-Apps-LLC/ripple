import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.title,
    this.hasRefresh = false,
  });
  final String title;
  final bool hasRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: hasRefresh
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (hasRefresh)
              Icon(
                Icons.refresh,
                size: 30,
                color: Colors.transparent,
              ),
            Text(
              title,
              style:
                  GoogleFonts.montserrat(color: AppColors.black, fontSize: 24),
            ),
            if (hasRefresh)
              Consumer<RoundupSettingProvider>(
                builder: (context, roundupSettingProvider, child) => IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.black,
                    size: 30,
                  ),
                  onPressed: () async {
                    await roundupSettingProvider.refresh();
                  },
                ),
              ),
          ],
        ),
        const Divider(),
        const SizedBox(
            // height: 14,
            ),
      ],
    );
  }
}
