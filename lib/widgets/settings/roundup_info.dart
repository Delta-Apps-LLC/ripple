import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/modals/edit_roundup_modal.dart';

class RoundupInfo extends StatefulWidget {
  const RoundupInfo({super.key, required this.provider});
  final RoundupSettingProvider provider;

  @override
  State<RoundupInfo> createState() => _RoundupInfoState();
}

class _RoundupInfoState extends State<RoundupInfo> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> roundupInfo = {
      "Round-up amount":
          "\$${widget.provider.roundupSetting!.roundupAmount!.toStringAsFixed(2)}",
      "Donation threshold":
          "\$${widget.provider.roundupSetting!.donationThreshold!.toStringAsFixed(2)}",
      "Monthly cap": widget.provider.roundupSetting!.hasMonthlyCap!
          ? "\$${widget.provider.roundupSetting!.monthlyCap!.toStringAsFixed(2)}"
          : 'None',
      "Round-up mode": "Automatic",
      "Round-ups active":
          widget.provider.roundupSetting!.isActive ? 'Yes' : 'No',
    };
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Round-Up Settings',
              style: GoogleFonts.montserrat(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
            IconButton(
              onPressed: () => showEditRoundupModal(context, widget.provider),
              icon: Icon(
                Icons.edit,
                size: 24,
              ),
              tooltip: 'Edit Info',
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
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
          child: Column(
            children: [
              ...roundupInfo.keys.map(
                (key) => Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: GoogleFonts.lato(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        roundupInfo[key] ?? '',
                        style: GoogleFonts.lato(
                            color: AppColors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
