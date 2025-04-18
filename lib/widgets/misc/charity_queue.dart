import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/lists/charity_list_item.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CharityQueue extends StatefulWidget {
  const CharityQueue({super.key});

  @override
  State<CharityQueue> createState() => _CharityQueueState();
}

class _CharityQueueState extends State<CharityQueue> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  late int currentCharityIndex;
  late int currentCarouselPage;

  @override
  void initState() {
    super.initState();
    final charityProvider =
        Provider.of<CharityProvider>(context, listen: false);
    currentCharityIndex = charityProvider.charityQueue
        .indexWhere((charity) => charity.id == charityProvider.nextCharity?.id);
    currentCarouselPage = currentCharityIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getOutlineColor(Charity charity, CharityProvider provider) {
    if (charity.id == provider.nextCharity?.id) {
      return AppColors.lightBlue;
    } else {
      return AppColors.darkGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharityProvider>(
      builder: (context, charityProvider, child) => Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 80,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              initialPage: currentCharityIndex,
              onPageChanged: (index, reason) {
                setState(() {
                  currentCarouselPage = index;
                });
              },
            ),
            items: [
              ...charityProvider.charityQueue.map(
                (charity) => Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getOutlineColor(charity, charityProvider),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CharityListItem(
                            charity: charity,
                            isSelected: false,
                            onTap: null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: charityProvider.charityQueue
                .map((c) => Container(
                      height: 8,
                      width: 8,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.darkBlue),
                        borderRadius: BorderRadius.circular(8),
                        color: (charityProvider.charityQueue
                                    .indexWhere((qc) => qc.id == c.id) ==
                                currentCarouselPage)
                            ? AppColors.darkBlue
                            : AppColors.white,
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
