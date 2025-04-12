import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/roundup_setting.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/utils/modals/stat_info_modal.dart';
import 'package:ripple/widgets/misc/page_title.dart';

Future<void> showEditRoundupModal(
    BuildContext context, RoundupSettingProvider provider) async {
  final settings = provider.roundupSetting;
  final formKey = GlobalKey<FormState>();
  final roundupAmountNotifier = ValueNotifier<int?>(settings?.roundupAmount);
  final thresholdNotifier = ValueNotifier<int?>(settings?.donationThreshold);
  final capNotifier = ValueNotifier<int?>(settings?.monthlyCap);
  final modeErrorNotifier = ValueNotifier<bool>(false);
  final selectedModeNotifier = ValueNotifier<RoundupMode>(
      settings?.roundupMode ?? RoundupMode.automatic);
  final isActiveNotifier = ValueNotifier<bool>(settings?.isActive ?? false);
  final hasCapNotifier = ValueNotifier<bool>(settings?.hasMonthlyCap ?? false);
  final loadingNotifier = ValueNotifier<bool>(false);

  final String amountDescription =
      'This is how much your transactions will be rounded up to.\n\nFor example, if you set this to \$2, and a transaction is \$4.83, it will round up \$1.17 instead of \$0.17.';
  final String thresholdDescription =
      'This is how many round-ups you need until the donation is actually sent to the charity. Until your round-ups exceed the threshold, we will keep track of how many round-ups have accumulated.';
  final String capDescription =
      'You can toggle this on or off to set a limit to how many donations are made each month.\n\nFor example, if you set the limit to \$30, we will automatically pause your round-ups until the month is over once you reach that limit.';
  final String modeDescription =
      'Automatic: ripple will automatically round-up all transactions from your connected accounts.\n\nManual: you will approve select transactions that you want to round-up.\n\nRandom: you choose a number of random transactions you want to be rounded-up each week.';

  Future<void> updateRoundupInfo(RoundupSettingProvider provider) async {
    if (formKey.currentState!.validate() && !modeErrorNotifier.value) {
      loadingNotifier.value = true;
      final updatedSetting = RoundupSetting(
        id: provider.roundupSetting?.id,
        userId: provider.roundupSetting!.userId,
        charityId: provider.roundupSetting!.charityId,
        roundupAmount: roundupAmountNotifier.value,
        donationThreshold: thresholdNotifier.value,
        monthlyCap: capNotifier.value,
        totalYtd: provider.roundupSetting!.totalYtd,
        runningTotal: provider.roundupSetting!.runningTotal,
        hasMonthlyCap: hasCapNotifier.value,
        roundupMode: selectedModeNotifier.value,
        isActive: isActiveNotifier.value,
      );
      await provider.setRoundupSetting(updatedSetting);
      loadingNotifier.value = false;
      Navigator.pop(context);
      showCustomSnackbar(
          context, 'Your round-up settings have been updated', AppColors.green);
    }
  }

  Widget buildNumberForm(
    String label,
    String description,
    ValueNotifier<int?> variable,
    int initDefault,
    int minValue,
    int maxValue,
    bool showLabel,
  ) {
    return Column(
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.transparent,
                  size: 26,
                ),
                onPressed: null,
              ),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: AppColors.black,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.darkBlue,
                  size: 26,
                ),
                onPressed: () => showInfoModal(context, null, description),
              ),
            ],
          ),
        ValueListenableBuilder<int?>(
          valueListenable: variable,
          builder: (context, value, child) => InputQty.int(
            minVal: minValue,
            initVal: value ?? initDefault,
            maxVal: maxValue,
            steps: 1,
            decoration: QtyDecorationProps(
              border: const OutlineInputBorder(),
              btnColor: AppColors.lightBlue,
              width: 15,
              minusButtonConstrains:
                  BoxConstraints(minWidth: 40, minHeight: 40),
              plusButtonConstrains: BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            qtyFormProps: QtyFormProps(
              keyboardType: TextInputType.number,
              cursorColor: AppColors.black,
              style: GoogleFonts.lato(color: AppColors.black, fontSize: 20),
            ),
            onQtyChanged: (q) {
              variable.value = q as int;
            },
          ),
        ),
      ],
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<RoundupSettingProvider>(
        builder: (context, roundupSettingProvider, child) => AlertDialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.only(left: 14, right: 14),
          title: PageTitle(title: 'Edit Round-up Settings'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildNumberForm('Round-up Amount', amountDescription,
                            roundupAmountNotifier, 1, 1, 5, true),
                        const SizedBox(height: 8),
                        buildNumberForm(
                            'Donation Threshold',
                            thresholdDescription,
                            thresholdNotifier,
                            5,
                            3,
                            15,
                            true),
                        const SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.transparent,
                                size: 26,
                              ),
                              onPressed: null,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ValueListenableBuilder<RoundupMode>(
                                valueListenable: selectedModeNotifier,
                                builder: (context, mode, child) =>
                                    DropdownButtonFormField<RoundupMode>(
                                  decoration: InputDecoration(
                                    labelText: 'Roundup Mode',
                                    border: OutlineInputBorder(),
                                    focusColor: AppColors.black,
                                    focusedBorder: OutlineInputBorder(),
                                    labelStyle: GoogleFonts.montserrat(
                                        color: AppColors.black, fontSize: 20),
                                  ),
                                  value: mode,
                                  items: RoundupMode.values
                                      .map((RoundupMode value) {
                                    return DropdownMenuItem<RoundupMode>(
                                      value: value,
                                      child: Text(
                                          value.toString().split('.').last),
                                    );
                                  }).toList(),
                                  onChanged: (RoundupMode? newValue) {
                                    selectedModeNotifier.value = newValue!;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a roundup mode';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: AppColors.darkBlue,
                                size: 26,
                              ),
                              onPressed: () =>
                                  showInfoModal(context, null, modeDescription),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.transparent,
                                size: 26,
                              ),
                              onPressed: null,
                            ),
                            Text(
                              'Monthly Cap\nOn/Off',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: AppColors.black, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: hasCapNotifier,
                              builder: (context, hasCap, child) => Switch(
                                activeColor: AppColors.darkBlue,
                                inactiveTrackColor: AppColors.lightGray,
                                value: hasCap,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    hasCapNotifier.value = value;
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: AppColors.darkBlue,
                                size: 26,
                              ),
                              onPressed: () =>
                                  showInfoModal(context, null, capDescription),
                            ),
                          ],
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: hasCapNotifier,
                          builder: (context, hasCap, child) {
                            if (hasCap) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 10),
                                child: buildNumberForm(
                                    'Monthly Cap',
                                    capDescription,
                                    capNotifier,
                                    25,
                                    15,
                                    1000,
                                    false),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Turn Round-\nups On/Off',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: AppColors.black, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isActiveNotifier,
                              builder: (context, isActive, child) => Switch(
                                activeColor: AppColors.darkBlue,
                                inactiveTrackColor: AppColors.lightGray,
                                value: isActive,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    isActiveNotifier.value = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => updateRoundupInfo(roundupSettingProvider),
              child: ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier,
                builder: (context, loading, child) => loading
                    ? CircularProgressIndicator(
                        color: AppColors.darkBlue,
                      )
                    : Text(
                        'Submit',
                        style: GoogleFonts.montserrat(
                          color: AppColors.black,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.montserrat(
                  color: AppColors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
