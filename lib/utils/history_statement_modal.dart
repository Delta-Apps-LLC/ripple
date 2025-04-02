import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:ripple/models/address.dart';
import 'package:ripple/models/donation_history.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/providers/donation_history_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:provider/provider.dart';
import 'package:ripple/utils/snackbar.dart';

void showStatementModal(
    BuildContext context, DonationHistoryProvider provider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                        'Your Statements',
                        style: GoogleFonts.montserrat(
                          color: AppColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.years.map((year) {
                        return Column(
                          children: [
                            Text(
                              year.toString(),
                              style: GoogleFonts.lato(
                                  color: AppColors.black, fontSize: 18),
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: List.generate(12, (monthIndex) {
                                final monthName = _getMonthName(monthIndex + 1)
                                    .substring(0, 3);
                                return GestureDetector(
                                  onTap: () {
                                    _showMonthHistoryModal(context, provider,
                                        year, monthIndex + 1);
                                  },
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.lightBlue.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        monthName,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),
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
                ),
              );
            },
          );
        },
      );
    },
  );
}

String formatDate(DateTime timestamp) {
  final day = timestamp.day;
  final month = timestamp.month;
  final year = timestamp.year;
  final monthStr = switch (month) {
    1 => 'January',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    12 => 'December',
    _ => 'Invalid Month',
  };

  return '$monthStr $day, $year';
}

String _getMonthName(int month) {
  return switch (month) {
    1 => 'January',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    12 => 'December',
    int() => '',
  };
}

Future<void> _showMonthHistoryModal(BuildContext context,
    DonationHistoryProvider provider, int year, int month) async {
  final loadingNotifier = ValueNotifier<bool>(false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<UserIdentityProvider>(
        builder: (context, userIdentityProvider, child) => AlertDialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.only(left: 14, right: 14),
          title: Column(
            children: [
              Text(
                '${_getMonthName(month)}, $year',
                style: GoogleFonts.montserrat(color: AppColors.black),
              ),
              const Divider(),
            ],
          ),
          content: Consumer<DonationHistoryProvider>(
            builder: (context, donationHistoryProvider, child) {
              final monthHistory = donationHistoryProvider.allDonationHistory
                  .where((donation) =>
                      donation.donationDate.year == year &&
                      donation.donationDate.month == month)
                  .toList();

              double totalDonations = monthHistory.fold(
                  0, (sum, item) => sum + item.donationAmount);

              if (monthHistory.isEmpty) {
                return const Text("No donations for this month");
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.maxFinite,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/ripple-logo-sm.png',
                              height: 40,
                            ),
                            Text(
                              'ripple',
                              style: GoogleFonts.montserrat(
                                  color: AppColors.black, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${userIdentityProvider.person?.firstName} ${userIdentityProvider.person?.lastName}',
                              style: GoogleFonts.lato(
                                  color: AppColors.black, fontSize: 15),
                            ),
                            Text(
                              '${userIdentityProvider.person?.address?.formatAddress()}',
                              style: GoogleFonts.lato(
                                  color: AppColors.black, fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Total Donations: \$${totalDonations.toStringAsFixed(2)}',
                      style: GoogleFonts.montserrat(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: monthHistory.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10.0);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatDate(
                                              monthHistory[index].donationDate),
                                          style: GoogleFonts.montserrat(
                                              color: AppColors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          monthHistory[index].charityName,
                                          style: GoogleFonts.montserrat(
                                              color: AppColors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${monthHistory[index].donationAmount.toStringAsFixed(2)}',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (userIdentityProvider.person?.address == null ||
                    userIdentityProvider.person!.address!.line1!.isEmpty) {
                  _showAddressModal(context);
                } else {
                  loadingNotifier.value = true;
                  _generateAndShareMonthHistoryPdf(
                      context, provider, year, month);
                  await Future.delayed(Duration(seconds: 2));
                  loadingNotifier.value = false;
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier,
                builder: (context, loading, child) => loading
                    ? CircularProgressIndicator(
                        color: AppColors.darkBlue,
                      )
                    : Text(
                        'Download',
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

Future<void> _generateAndShareMonthHistoryPdf(BuildContext context,
    DonationHistoryProvider provider, int year, int month) async {
  final monthHistory = provider.allDonationHistory
      .where((donation) =>
          donation.donationDate.year == year &&
          donation.donationDate.month == month)
      .toList();

  double totalDonations =
      monthHistory.fold(0, (sum, item) => sum + item.donationAmount);

  final pdf = pw.Document();
  // Load the image from assets
  final ByteData imageData =
      await rootBundle.load('assets/images/ripple-logo-sm.png');
  final Uint8List imageBytes = imageData.buffer.asUint8List();
  final pw.MemoryImage logoImage = pw.MemoryImage(imageBytes);

  final int firstPageItems = 14;
  final int otherPageItems = 17;

  // Split the donation list into chunks
  final List<List<DonationHistory>> chunks = [];
  int startIndex = 0;
  int endIndex = firstPageItems > monthHistory.length
      ? monthHistory.length
      : firstPageItems;

  // Add the first page chunk
  chunks.add(monthHistory.sublist(startIndex, endIndex));
  startIndex = endIndex;

  // Add the rest of the chunks
  while (startIndex < monthHistory.length) {
    endIndex = startIndex + otherPageItems > monthHistory.length
        ? monthHistory.length
        : startIndex + otherPageItems;
    chunks.add(monthHistory.sublist(startIndex, endIndex));
    startIndex = endIndex;
  }

  for (final chunk in chunks) {
    pdf.addPage(pw.Page(
      build: (pw.Context pdfContext) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (chunks.indexOf(chunk) == 0)
              pw.Column(children: [
                pw.Text('${_getMonthName(month)}, $year',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Image(logoImage, width: 50, height: 50),
                      pw.Text('ripple', style: pw.TextStyle(fontSize: 18)),
                    ]),
                    pw.Column(children: [
                      pw.Text(
                          '${Provider.of<UserIdentityProvider>(context, listen: false).person?.firstName} ${Provider.of<UserIdentityProvider>(context, listen: false).person?.lastName}'),
                      pw.Text(
                          '${Provider.of<UserIdentityProvider>(context, listen: false).person?.address?.formatAddress()}'),
                    ]),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                    'Total Donations: \$${totalDonations.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 16),
              ]),
            pw.Column(
                children: chunk.map((donation) {
              return pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 6.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(DateFormat('EEE, M/d/y')
                              .format(donation.donationDate)),
                          pw.Text(donation.charityName),
                        ]),
                    pw.Text('\$${donation.donationAmount.toStringAsFixed(2)}'),
                  ],
                ),
              );
            }).toList())
          ],
        );
      },
    ));
  }

  await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'ripple_donation_statement_$year-$month.pdf');
}

void _showAddressModal(BuildContext context) {
  final String info =
      'For legal and official use of this statement, such as for tax purposes, please enter your address. This is a one-time entry.';
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final loadingNotifier = ValueNotifier<bool>(false);
  final stateErrorNotifier = ValueNotifier<bool>(false);
  final selectedStateNotifier = ValueNotifier<String?>(null);

  final List<DropdownMenuEntry<String?>> states = [
    const DropdownMenuEntry(
      value: null,
      label: 'Select State',
    ),
    const DropdownMenuEntry(value: 'AL', label: 'AL'),
    const DropdownMenuEntry(value: 'AK', label: 'AK'),
    const DropdownMenuEntry(value: 'AZ', label: 'AZ'),
    const DropdownMenuEntry(value: 'AR', label: 'AR'),
    const DropdownMenuEntry(value: 'CA', label: 'CA'),
    const DropdownMenuEntry(value: 'CO', label: 'CO'),
    const DropdownMenuEntry(value: 'CT', label: 'CT'),
    const DropdownMenuEntry(value: 'DE', label: 'DE'),
    const DropdownMenuEntry(value: 'FL', label: 'FL'),
    const DropdownMenuEntry(value: 'GA', label: 'GA'),
    const DropdownMenuEntry(value: 'HI', label: 'HI'),
    const DropdownMenuEntry(value: 'ID', label: 'ID'),
    const DropdownMenuEntry(value: 'IL', label: 'IL'),
    const DropdownMenuEntry(value: 'IN', label: 'IN'),
    const DropdownMenuEntry(value: 'IA', label: 'IA'),
    const DropdownMenuEntry(value: 'KS', label: 'KS'),
    const DropdownMenuEntry(value: 'KY', label: 'KY'),
    const DropdownMenuEntry(value: 'LA', label: 'LA'),
    const DropdownMenuEntry(value: 'ME', label: 'ME'),
    const DropdownMenuEntry(value: 'MD', label: 'MD'),
    const DropdownMenuEntry(value: 'MA', label: 'MA'),
    const DropdownMenuEntry(value: 'MI', label: 'MI'),
    const DropdownMenuEntry(value: 'MN', label: 'MN'),
    const DropdownMenuEntry(value: 'MS', label: 'MS'),
    const DropdownMenuEntry(value: 'MO', label: 'MO'),
    const DropdownMenuEntry(value: 'MT', label: 'MT'),
    const DropdownMenuEntry(value: 'NE', label: 'NE'),
    const DropdownMenuEntry(value: 'NV', label: 'NV'),
    const DropdownMenuEntry(value: 'NH', label: 'NH'),
    const DropdownMenuEntry(value: 'NJ', label: 'NJ'),
    const DropdownMenuEntry(value: 'NM', label: 'NM'),
    const DropdownMenuEntry(value: 'NY', label: 'NY'),
    const DropdownMenuEntry(value: 'NC', label: 'NC'),
    const DropdownMenuEntry(value: 'ND', label: 'ND'),
    const DropdownMenuEntry(value: 'OH', label: 'OH'),
    const DropdownMenuEntry(value: 'OK', label: 'OK'),
    const DropdownMenuEntry(value: 'OR', label: 'OR'),
    const DropdownMenuEntry(value: 'PA', label: 'PA'),
    const DropdownMenuEntry(value: 'RI', label: 'RI'),
    const DropdownMenuEntry(value: 'SC', label: 'SC'),
    const DropdownMenuEntry(value: 'SD', label: 'SD'),
    const DropdownMenuEntry(value: 'TN', label: 'TN'),
    const DropdownMenuEntry(value: 'TX', label: 'TX'),
    const DropdownMenuEntry(value: 'UT', label: 'UT'),
    const DropdownMenuEntry(value: 'VT', label: 'VT'),
    const DropdownMenuEntry(value: 'VA', label: 'VA'),
    const DropdownMenuEntry(value: 'WA', label: 'WA'),
    const DropdownMenuEntry(value: 'WV', label: 'WV'),
    const DropdownMenuEntry(value: 'WI', label: 'WI'),
    const DropdownMenuEntry(value: 'WY', label: 'WY'),
  ];

  Future<void> submitAddress(UserIdentityProvider provider) async {
    stateErrorNotifier.value = selectedStateNotifier.value == null;
    if (formKey.currentState!.validate() && !stateErrorNotifier.value) {
      loadingNotifier.value = true;
      final updatedPerson = Person(
        id: provider.person?.id,
        firstName: provider.person?.firstName ?? '',
        lastName: provider.person?.lastName ?? '',
        email: provider.person?.email ?? '',
        onboardLevel: provider.person?.onboardLevel ?? OnboardLevel.complete,
        address: Address(
          line1: addressLine1Controller.text,
          line2: addressLine2Controller.text,
          city: cityController.text,
          state: selectedStateNotifier.value,
          zip: zipController.text,
        ),
      );
      await provider.updatePerson(updatedPerson);
      loadingNotifier.value = false;
      Navigator.pop(context);
    }
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UserIdentityProvider>(
          builder: (context, userIdentityProvider, child) => AlertDialog(
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.only(left: 14, right: 14),
            title: Column(
              children: [
                Text(
                  'Address Needed',
                  style: GoogleFonts.montserrat(color: AppColors.black),
                ),
                const Divider(),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      info,
                      style: GoogleFonts.lato(
                        color: AppColors.black,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: addressLine1Controller,
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: AppColors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Address line 1',
                              labelStyle: TextStyle(color: AppColors.black),
                              hintText: 'Enter your street address',
                              hintStyle: TextStyle(color: AppColors.black),
                              focusColor: AppColors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppColors.black)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: AppColors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your street address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: addressLine2Controller,
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: AppColors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Address line 2',
                              labelStyle: TextStyle(color: AppColors.black),
                              hintText: 'Apt/Suite/Unit (Optional)',
                              hintStyle: TextStyle(color: AppColors.black),
                              focusColor: AppColors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppColors.black)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: AppColors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: cityController,
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: AppColors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(color: AppColors.black),
                              hintText: 'Enter your city',
                              hintStyle: TextStyle(color: AppColors.black),
                              focusColor: AppColors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppColors.black)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: AppColors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: stateErrorNotifier,
                                builder: (context, stateError, child) =>
                                    ValueListenableBuilder<String?>(
                                  valueListenable: selectedStateNotifier,
                                  builder: (context, selectedState, child) =>
                                      DropdownMenu(
                                    menuHeight: 300,
                                    errorText: stateError
                                        ? 'Please select your state'
                                        : null,
                                    dropdownMenuEntries: states,
                                    initialSelection: selectedState,
                                    onSelected: (value) {
                                      selectedStateNotifier.value = value;
                                      stateErrorNotifier.value = value == null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: zipController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  cursorColor: AppColors.black,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 5,
                                  decoration: InputDecoration(
                                    labelText: 'Zipcode',
                                    labelStyle:
                                        TextStyle(color: AppColors.black),
                                    hintText: 'Enter your 5 digit zipcode',
                                    hintStyle:
                                        TextStyle(color: AppColors.black),
                                    focusColor: AppColors.black,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide:
                                            BorderSide(color: AppColors.black)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: AppColors.black),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your 5 digit zipcode';
                                    }

                                    if (value.length != 5) {
                                      return 'Zipcode must be 5 digits long';
                                    }
                                    return null;
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
                onPressed: () => submitAddress(userIdentityProvider),
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
      });
}
