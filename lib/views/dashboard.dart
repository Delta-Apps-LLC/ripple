import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/charity_modal.dart';
import 'package:ripple/widgets/progress_wave.dart';
import 'package:ripple/widgets/stat_tile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Charity> charities = [
      Charity(
        charityName: 'Feeding America',
        charityDescription:
            'Feeding America is a nationwide network of food banks that provides meals to people facing hunger across the United States. They work to address both immediate food needs and systemic causes of food insecurity.',
        logo: CharityLogo.feedingAmerica,
        isActive: true,
        cause: CharityCause.agriculture,
      ),
      Charity(
        charityName: 'The Salvation Army',
        charityDescription:
            'The Salvation Army provides a wide range of social services, including disaster relief, food assistance, and rehabilitation programs, to those in need. They aim to address both physical and spiritual needs within communities.',
        logo: CharityLogo.salvationArmy,
        isActive: true,
        cause: CharityCause.humanitarian,
      ),
    ];

    String getCharityLogoAsset(CharityLogo logo) {
      switch (logo) {
        case CharityLogo.stJude:
          return 'assets/images/charities/st_jude_logo.png';
        case CharityLogo.feedingAmerica:
          return 'assets/images/charities/feeding_america_logo.png';
        case CharityLogo.our:
          return 'assets/images/charities/our_logo.png';
        case CharityLogo.salvationArmy:
          return 'assets/images/charities/salvation_army_logo.png';
        default:
          return '';
      }
    }

    return Consumer<RoundupSettingProvider>(
      builder: (context, roundupSettingProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Dashboard',
            style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 28),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: StatTile(
              stat: '\$65.00',
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
                    stat: '\$1.76',
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
                  child: AnimatedProgressWave(value: 2.5),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Your Charities This Year',
            style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 28),
          ),
          const Divider(),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  children: charities.map((charity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () => showCharityDetails(context, charity),
                    child: Image.asset(
                      getCharityLogoAsset(charity.logo),
                      scale: 0.75,
                    ),
                  ),
                );
              }).toList()),
            ),
          )
        ],
      ),
    );
  }
}
