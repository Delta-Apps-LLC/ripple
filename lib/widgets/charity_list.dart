import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/charity_list_item.dart';

class CharityList extends StatefulWidget {
  const CharityList({super.key, required this.onCharitySelected});
  final Function(Charity?) onCharitySelected;

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
              ? CircularProgressIndicator(
                  color: AppColors.darkBlue,
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.425,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 18.0);
                    },
                    itemCount: charityProvider.charities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CharityListItem(
                        charity: charityProvider.charities[index],
                        isSelected: _selectedCharityIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCharityIndex = index;
                            widget.onCharitySelected(
                                charityProvider.charities[index]);
                          });
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
