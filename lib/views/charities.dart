import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/widgets/lists/charity_list.dart';
import 'package:ripple/widgets/lists/charity_list_item.dart';
import 'package:ripple/widgets/misc/charity_queue.dart';
import 'package:ripple/widgets/misc/custom_icon_button.dart';
import 'package:ripple/widgets/misc/page_title.dart';

class CharityView extends StatefulWidget {
  const CharityView({super.key});

  @override
  State<CharityView> createState() => _CharityViewState();
}

class _CharityViewState extends State<CharityView> {
  bool _loading = false;

  saveQueueEdits(CharityProvider charityProvider) async {
    setState(() => _loading = true);
    await charityProvider.saveQueueEdits();
    setState(() => _loading = false);
    showCustomSnackbar(
        context, 'Your charity queue has been updated', AppColors.green);
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
              title: 'Your Charity Queue',
            ),
            (charityProvider.isLoadingCharities)
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 30),
                    child: charityProvider.charityQueue.length > 1
                        ? CharityQueue()
                        : CharityListItem(
                            charity: charityProvider.charityQueue.first,
                            isSelected: false,
                            onTap: null,
                          ),
                  ),
            PageTitle(
              title: 'All Charities',
            ),
            CharityList(
              displayStar: true,
            ),
            if (_loading)
              CircularProgressIndicator(
                color: AppColors.darkBlue,
              ),
            Consumer<CharityProvider>(
              builder: (context, charityProvider, child) => Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomIconButton(
                  text: 'Save Changes',
                  colors: [AppColors.darkGray, AppColors.purple],
                  function: () => saveQueueEdits(charityProvider),
                  disabled: !charityProvider.hasQueueBeenModified,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
