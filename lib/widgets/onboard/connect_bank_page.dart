import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/models/person.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/custom_scaffold.dart';

class ConnectBankPage extends StatefulWidget {
  const ConnectBankPage({super.key});

  @override
  State<ConnectBankPage> createState() => _ConnectBankPageState();
}

class _ConnectBankPageState extends State<ConnectBankPage> {
  bool _loading = false;

  void openPlaid(UserIdentityProvider userIdentityProvider) async {
    setState(() => _loading = true);
    final updatedPerson = Person(
      id: userIdentityProvider.person!.id,
      firstName: userIdentityProvider.person!.firstName,
      lastName: userIdentityProvider.person!.lastName,
      email: userIdentityProvider.person!.email,
      onboardLevel: OnboardLevel.complete,
    );
    await userIdentityProvider.updatePerson(updatedPerson);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CustomScaffold()));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final plaidIntro =
        'Ripple uses Plaid to authenticate and connect your bank account to perform the round-up donations. Click the button below to be taken to Plaid.';
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        children: [
          Text(
            plaidIntro,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(color: AppColors.black, fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 50.0),
            child: Container(
              width: 300,
              height: 100,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightGray, AppColors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Consumer<UserIdentityProvider>(
                builder: (context, userIdentityProvider, child) =>
                    ElevatedButton(
                        style: buttonStyle,
                        onPressed: () => openPlaid(userIdentityProvider),
                        child: _loading
                            ? CircularProgressIndicator(
                                color: AppColors.darkBlue,
                              )
                            : Text(
                                'Continue to Plaid',
                                style: GoogleFonts.montserrat(
                                    color: AppColors.black, fontSize: 20),
                              )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    elevation: WidgetStatePropertyAll(0),
    shadowColor: WidgetStatePropertyAll(Colors.transparent),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
