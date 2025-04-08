import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';

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
                size: 28,
                color: Colors.transparent,
              ),
            Expanded(
              child: Text(
                title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: AppColors.black, fontSize: 24),
              ),
            ),
            if (hasRefresh)
              Consumer<RoundupSettingProvider>(
                builder: (context, roundupSettingProvider, child) => IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.black,
                    size: 28,
                  ),
                  onPressed: () async {
                    showCustomSnackbar(context, 'Refreshing dashboard data...',
                        AppColors.green);
                    await roundupSettingProvider.refresh();
                  },
                ),
              ),
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
