import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/widgets/lists/charity_list_item.dart';

class CharityList extends StatefulWidget {
  const CharityList(
      {super.key, this.onCharitySelected, this.displayStar = false});
  final Function(Charity?)? onCharitySelected;
  final bool displayStar;

  @override
  State<CharityList> createState() => _CharityListState();
}

class _CharityListState extends State<CharityList> {
  int _selectedCharityIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<CharityProvider>(
      builder: (context, charityProvider, child) =>
          charityProvider.isLoadingCharities
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkBlue,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10.0);
                        },
                        itemCount: charityProvider.charities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CharityListItem(
                            charity: charityProvider.charities[index],
                            isSelected: _selectedCharityIndex == index,
                            displayStar: widget.displayStar,
                            onTap: widget.onCharitySelected != null
                                ? () {
                                    if (!charityProvider
                                        .charities[index].isActive) {
                                      showCustomSnackbar(
                                          context,
                                          'This charity is currently inactive, please choose another one',
                                          AppColors.errorRed);
                                    } else {
                                      setState(() {
                                        _selectedCharityIndex = index;
                                        widget.onCharitySelected!(
                                            charityProvider.charities[index]);
                                      });
                                    }
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
