import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/widgets/lists/charity_list.dart';
import 'package:ripple/widgets/lists/charity_list_item.dart';
import 'package:ripple/widgets/misc/charity_queue.dart';
import 'package:ripple/widgets/misc/page_title.dart';

class CharityView extends StatefulWidget {
  const CharityView({super.key});

  @override
  State<CharityView> createState() => _CharityViewState();
}

class _CharityViewState extends State<CharityView> {
  bool _loading = false;
  Widget _buildTrailingButton(CharityProvider charityProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: IconButton(
        icon: Icon(
          Icons.save,
          color: charityProvider.hasQueueBeenModified
              ? AppColors.black
              : AppColors.lightGray,
          size: 28,
        ),
        tooltip: 'Save Changes',
        onPressed: charityProvider.hasQueueBeenModified
            ? () async {
                setState(() => _loading = true);
                await charityProvider.saveQueueEdits();
                setState(() => _loading = false);
                if (context.mounted) {
                  showCustomSnackbar(
                    context,
                    'Your charity queue has been updated',
                    AppColors.green,
                  );
                }
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharityProvider>(
      builder: (context, charityProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          PageTitle(
            title: 'Your Charity Queue',
            subTitle:
                'Highlighted charity will receive the next donation. Inactive charities will be skipped.',
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
            subTitle: 'Faded charities are currently inactive',
            trailingButton: _loading
                ? CircularProgressIndicator(
                    color: AppColors.darkBlue,
                  )
                : _buildTrailingButton(charityProvider),
          ),
          Expanded(
            child: CharityList(
              displayStar: true,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
