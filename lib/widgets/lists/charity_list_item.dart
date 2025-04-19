import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/charity.dart';
import 'package:ripple/providers/charity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/parse_charity_info.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/utils/modals/charity_modal.dart';

class CharityListItem extends StatefulWidget {
  final Charity charity;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool displayStar;

  const CharityListItem({
    super.key,
    required this.charity,
    required this.isSelected,
    this.onTap,
    this.displayStar = false,
  });

  @override
  State<CharityListItem> createState() => _CharityListItemState();
}

class _CharityListItemState extends State<CharityListItem> {
  bool isInQueue(CharityProvider provider) {
    final index = provider.charityQueue
        .indexWhere((charity) => charity.id == widget.charity.id);
    return index != -1;
  }

  void addOrRemoveFromQueue(CharityProvider charityProvider) {
    if (isInQueue(charityProvider)) {
      if (charityProvider.charityQueue.length == 1) {
        showCustomSnackbar(
            context,
            'You must keep at least one charity in the queue',
            AppColors.errorRed);
      } else {
        charityProvider.removeFromQueue(widget.charity);
      }
    } else {
      if (charityProvider.charityQueue.length == 4) {
        showCustomSnackbar(
            context,
            'You cannot have more than four charities in your queue',
            AppColors.errorRed);
      } else {
        if (!widget.charity.isActive) {
          showCustomSnackbar(
              context,
              'This charity is current inactive, please choose another one',
              AppColors.errorRed);
        } else {
          charityProvider.addToQueue(widget.charity);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // TODO: logic for inactive charity for onboard page
      child: Opacity(
        opacity: widget.charity.isActive ? 1.0 : 0.4,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  widget.isSelected ? AppColors.lightBlue : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightGray.withOpacity(0.4),
                  radius: 25,
                  child: Image.asset(
                    getCharityLogoAsset(widget.charity.logo),
                    height: 25,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.charity.charityName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            color: AppColors.black, fontSize: 16),
                      ),
                      Text(
                        'Cause: ${getCharityCause(widget.charity.cause)}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                            color: AppColors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppColors.green,
                    size: 28,
                  ),
                  onPressed: () => showCharityDetails(context, widget.charity),
                ),
                if (widget.displayStar)
                  Consumer<CharityProvider>(
                    builder: (context, charityProvider, child) => IconButton(
                        icon: Icon(
                          isInQueue(charityProvider)
                              ? Icons.star
                              : Icons.star_outline,
                          color: AppColors.green,
                          size: 28,
                        ),
                        onPressed: () => addOrRemoveFromQueue(charityProvider)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
