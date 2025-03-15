import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/widgets/page_title.dart';

class CharityView extends StatefulWidget {
  const CharityView({super.key});

  @override
  State<CharityView> createState() => _CharityViewState();
}

class _CharityViewState extends State<CharityView> {
  Charity? _selectedCharity;

  onCharitySelected(Charity? selectedCharity) {
    setState(() {
      _selectedCharity = selectedCharity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<CharityProvider>(
            builder: (context, charityProvider, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PageTitle(title: 'Your Selected Charity'),
                  ],
                )),
        Consumer<RoundupSettingProvider>(
          builder: (context, roundupSettingProvider, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PageTitle(title: 'Other Charities'),
            ],
          ),
        ),
      ],
    );
  }
}
