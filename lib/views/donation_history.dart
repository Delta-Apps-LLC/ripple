import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/donation_history_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/history_filter_modal.dart';
import 'package:ripple/utils/history_statement_modal.dart';
import 'package:ripple/widgets/lists/donation_history_item.dart';
import 'package:ripple/widgets/misc/page_title.dart';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key});

  @override
  State<DonationHistoryView> createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> {
  String getFilterTitle(DonationHistoryProvider donationHistoryProvider) {
    if (donationHistoryProvider.donationYearFilter == null &&
        donationHistoryProvider.donationCharityFilter == null) {
      return 'All History';
    }

    if (donationHistoryProvider.donationYearFilter == null &&
        donationHistoryProvider.donationCharityFilter != null) {
      return donationHistoryProvider.donationCharityFilter?.charityName ?? '';
    }

    if (donationHistoryProvider.donationYearFilter != null &&
        donationHistoryProvider.donationCharityFilter == null) {
      return donationHistoryProvider.donationYearFilter.toString();
    }

    if (donationHistoryProvider.donationYearFilter != null &&
        donationHistoryProvider.donationCharityFilter != null) {
      return '${donationHistoryProvider.donationYearFilter.toString()}\n${donationHistoryProvider.donationCharityFilter?.charityName}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DonationHistoryProvider>(
      builder: (context, donationHistoryProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          PageTitle(title: 'Your Donation History',),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  getFilterTitle(donationHistoryProvider),
                  style: GoogleFonts.montserrat(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        showFilterModal(context, donationHistoryProvider),
                    icon: Icon(
                      Icons.filter_list,
                      size: 28,
                    ),
                    tooltip: 'Filters',
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () =>
                        showStatementModal(context, donationHistoryProvider),
                    icon: Icon(
                      Icons.description_outlined,
                      size: 28,
                    ),
                    tooltip: 'Statements',
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: donationHistoryProvider.loadingHistory
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  )
                : ListView.separated(
                    itemCount:
                        donationHistoryProvider.filteredDonationHistory.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10.0);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return DonationHistoryItem(
                        item: donationHistoryProvider
                            .filteredDonationHistory[index],
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
