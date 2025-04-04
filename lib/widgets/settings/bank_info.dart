import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';

class BankInfo extends StatefulWidget {
  const BankInfo({super.key, required this.provider});
  final RoundupSettingProvider provider;

  @override
  State<BankInfo> createState() => _BankInfoState();
}

class _BankInfoState extends State<BankInfo> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> roundupInfo = {
      "Bank": "Capital One",
      "Account": "Checking",
      "Account #": "*******2377",
    };
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bank Information',
              style: GoogleFonts.montserrat(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.edit,
                size: 24,
                color: Colors.transparent,
              ),
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
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Unlink',
                      style: GoogleFonts.montserrat(
                        color: AppColors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
