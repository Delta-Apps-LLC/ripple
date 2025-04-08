import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/constants.dart';
import 'package:ripple/models/address.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/misc/page_title.dart';

Future<void> showEditPiModal(
    BuildContext context, UserIdentityProvider provider) async {
  final Address? address = provider.person?.address;
  TextEditingController firstNameController =
      TextEditingController(text: provider.person?.firstName);
  TextEditingController lastNameController =
      TextEditingController(text: provider.person?.lastName);
  TextEditingController addressLine1Controller =
      TextEditingController(text: address?.line1);
  TextEditingController addressLine2Controller =
      TextEditingController(text: address?.line2);
  TextEditingController cityController =
      TextEditingController(text: address?.city);
  TextEditingController zipController =
      TextEditingController(text: address?.zip);
  final formKey = GlobalKey<FormState>();
  final stateErrorNotifier = ValueNotifier<bool>(false);
  final selectedStateNotifier = ValueNotifier<String?>(address?.state);
  final loadingNotifier = ValueNotifier<bool>(false);

  Future<void> updatePiInfo(UserIdentityProvider provider) async {
    if (formKey.currentState!.validate() && !stateErrorNotifier.value) {
      loadingNotifier.value = true;
      final updatedPerson = Person(
        id: provider.person?.id,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
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
          title: PageTitle(title: 'Edit Your Info'),
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
                        TextFormField(
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          cursorColor: AppColors.black,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'First name',
                            labelStyle: TextStyle(color: AppColors.black),
                            hintText: 'Enter your first name',
                            hintStyle: TextStyle(color: AppColors.black),
                            focusColor: AppColors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: AppColors.black)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: AppColors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          cursorColor: AppColors.black,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Last name',
                            labelStyle: TextStyle(color: AppColors.black),
                            hintText: 'Enter your last name',
                            hintStyle: TextStyle(color: AppColors.black),
                            focusColor: AppColors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: AppColors.black)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: AppColors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
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
                                borderSide: BorderSide(color: AppColors.black)),
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
                                borderSide: BorderSide(color: AppColors.black)),
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
                                borderSide: BorderSide(color: AppColors.black)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: AppColors.black),
                            ),
                          ),
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                (selectedStateNotifier.value != null ||
                                    zipController.text.isNotEmpty)) {
                              return 'City is required with State or Zip';
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
                                      ? 'State is required with City or Zip'
                                      : null,
                                  dropdownMenuEntries: states,
                                  initialSelection:
                                      address?.state ?? selectedState,
                                  onSelected: (value) {
                                    selectedStateNotifier.value = value;
                                    stateErrorNotifier.value =
                                        ((value == null) &&
                                            (cityController.text.isNotEmpty ||
                                                zipController.text.isNotEmpty));
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
                                  labelStyle: TextStyle(color: AppColors.black),
                                  hintText: 'Enter your 5 digit zipcode',
                                  hintStyle: TextStyle(color: AppColors.black),
                                  focusColor: AppColors.black,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: AppColors.black)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: AppColors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      (selectedStateNotifier.value != null ||
                                          cityController.text.isNotEmpty)) {
                                    return 'Zip is required with City or State';
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
              onPressed: () => updatePiInfo(userIdentityProvider),
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
