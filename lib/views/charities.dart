import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/models/roundup_setting.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/widgets/lists/charity_list.dart';
import 'package:ripple/widgets/lists/charity_list_item.dart';
import 'package:ripple/widgets/misc/custom_icon_button.dart';
import 'package:ripple/widgets/misc/page_title.dart';

class CharityView extends StatefulWidget {
  const CharityView({super.key});

  @override
  State<CharityView> createState() => _CharityViewState();
}

class _CharityViewState extends State<CharityView> {
  Charity? _selectedCharity;
  bool _loading = false;

  onCharitySelected(Charity? selectedCharity) {
    setState(() {
      _selectedCharity = selectedCharity;
    });
  }

  saveNewCharity(RoundupSettingProvider roundupSettingProvider) async {
    if (_selectedCharity != null) {
      setState(() => _loading = true);
      final newSetting = RoundupSetting(
        id: roundupSettingProvider.roundupSetting!.id,
        userId: roundupSettingProvider.roundupSetting!.userId,
        charityId: _selectedCharity!.id!,
        isActive: true,
        totalYtd: roundupSettingProvider.roundupSetting!.totalYtd,
        runningTotal: roundupSettingProvider.roundupSetting!.runningTotal,
        roundupAmount: roundupSettingProvider.roundupSetting!.roundupAmount,
        donationThreshold:
            roundupSettingProvider.roundupSetting!.donationThreshold,
        monthlyCap: roundupSettingProvider.roundupSetting!.monthlyCap,
        hasMonthlyCap: roundupSettingProvider.roundupSetting!.hasMonthlyCap,
        roundupMode: roundupSettingProvider.roundupSetting!.roundupMode,
      );
      await roundupSettingProvider.setRoundupSetting(newSetting);
      setState(() {
        _loading = false;
        _selectedCharity = null;
      });
      showCustomSnackbar(context, 'Your charity has been successfully updated',
          AppColors.green);
    } else {
      showCustomSnackbar(
          context, 'You must first select a charity', AppColors.errorRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharityProvider>(
      builder: (context, charityProvider, child) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PageTitle(
              title: 'Your Current Charity',
            ),
            (charityProvider.isLoadingCharities)
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 30),
                    child: CharityListItem(
                      charity: charityProvider.currentCharity,
                      isSelected: false,
                      onTap: () => onCharitySelected,
                    ),
                  ),
            PageTitle(
              title: 'Other Charities',
            ),
            CharityList(onCharitySelected: onCharitySelected),
            if (_loading)
              CircularProgressIndicator(
                color: AppColors.darkBlue,
              ),
            Consumer<RoundupSettingProvider>(
              builder: (context, roundupSettingProvider, child) => Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomIconButton(
                  text: 'Switch Charity',
                  colors: [AppColors.darkGray, AppColors.purple],
                  function: () => saveNewCharity(roundupSettingProvider),
                  disabled: _selectedCharity == null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
