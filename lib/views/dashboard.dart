import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/donation_history_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/charity_list_item.dart';
import 'package:ripple/widgets/page_title.dart';
import 'package:ripple/widgets/progress_wave.dart';
import 'package:ripple/widgets/stat_tile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    double getRemainingNeeded(RoundupSettingProvider roundupSettingProvider) {
      if (roundupSettingProvider.roundupSetting != null) {
        return roundupSettingProvider.roundupSetting!.donationThreshold!
                .toDouble() -
            roundupSettingProvider.roundupSetting!.runningTotal!;
      } else {
        return 0.0;
      }
    }

    return Consumer<RoundupSettingProvider>(
      builder: (context, roundupSettingProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: roundupSettingProvider.loadingRoundupSetting
            ? [
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkBlue,
                  ),
                ),
              ]
            : [
                PageTitle(
                  title: 'Your Dashboard',
                  hasRefresh: true,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: StatTile(
                    stat:
                        '\$${roundupSettingProvider.roundupSetting?.totalYtd?.toStringAsFixed(2)}',
                    label: 'Donated this year',
                    description:
                        'This is the total amount of donations you have made this year with all of your roundups combined.',
                    isFullWidth: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          stat:
                              '\$${getRemainingNeeded(roundupSettingProvider).toStringAsFixed(2)}',
                          label: 'Until next donation',
                          description:
                              'This is the amount of roundups needed until you reach the donation threshold and the charity you have selected receives your donation.',
                          isFullWidth: false,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: AnimatedProgressWave(
                          value: roundupSettingProvider
                                  .roundupSetting?.runningTotal ??
                              0.0,
                          threshold: roundupSettingProvider
                                  .roundupSetting?.donationThreshold ??
                              5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                PageTitle(title: 'Your Charities This Year'),
                Consumer<DonationHistoryProvider>(
                  builder: (context, donationHistoryProvider, child) =>
                      Expanded(
                    child: Flexible(
                      child: Column(
                          children: donationHistoryProvider.loadingHistory
                              ? [
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.darkBlue,
                                    ),
                                  )
                                ]
                              : [
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 18.0);
                                      },
                                      itemCount: donationHistoryProvider
                                          .charitiesThisYear.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CharityListItem(
                                          charity: donationHistoryProvider
                                              .charitiesThisYear[index],
                                          isSelected: false,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                    ),
                  ),
                )
              ],
      ),
    );
  }
}
