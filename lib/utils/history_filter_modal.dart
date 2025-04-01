import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/donation_history_provider.dart';
import 'package:ripple/themes.dart';

void showFilterModal(BuildContext context, DonationHistoryProvider provider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        int? selectedYear = provider.donationYearFilter;
        Charity? selectedCharity = provider.donationCharityFilter;

        final List<DropdownMenuEntry<int?>> years = [
          const DropdownMenuEntry(
            value: null,
            label: 'All Years',
          ),
          ...provider.years.map((year) => DropdownMenuEntry(
                value: year,
                label: year.toString(),
              )),
        ];

        final List<DropdownMenuEntry<Charity?>> charities = [
          const DropdownMenuEntry(
            value: null,
            label: 'All Charities',
          ),
          ...provider.charities.map((charity) => DropdownMenuEntry(
                value: charity,
                label: charity.charityName.toString(),
              )),
        ];
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filters',
                    style: GoogleFonts.montserrat(
                      color: AppColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By Year',
                              style: GoogleFonts.lato(
                                  color: AppColors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownMenu(
                              dropdownMenuEntries: years,
                              initialSelection: selectedYear,
                              onSelected: (value) {
                                provider.setDonationYearFilter(value);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By Charity',
                              style: GoogleFonts.lato(
                                  color: AppColors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            DropdownMenu(
                              dropdownMenuEntries: charities,
                              initialSelection: selectedCharity,
                              onSelected: (value) {
                                provider.setDonationCharityFilter(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          provider.setDonationYearFilter(null);
                          provider.setDonationCharityFilter(null);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Reset',
                          style: GoogleFonts.montserrat(
                              color: AppColors.black, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Close',
                          style: GoogleFonts.montserrat(
                              color: AppColors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      });
    },
  );
}
