import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/providers/roundup_setting_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/custom_material_app.dart';
import 'package:ripple/widgets/page_title.dart';
import 'package:ripple/widgets/pi_info.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool loading = false;

  Future<void> showConfirmDialog(
      BuildContext context, String message, VoidCallback function) async {
    Future<bool?> result = showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            'Confirm',
            style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 20),
          ),
          content: Text(
            message,
            style: GoogleFonts.lato(color: AppColors.black, fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.white)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style: GoogleFonts.montserrat(
                    color: AppColors.black, fontSize: 18),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.white)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Yes',
                style: GoogleFonts.montserrat(
                    color: AppColors.black, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    result.then((value) async {
      if (value == true) {
        setState(() => loading = true);
        function();
        setState(() => loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Consumer<UserIdentityProvider>(
        builder: (context, userIdentityProvider, child) =>
            Consumer<RoundupSettingProvider>(
          builder: (context, roundupSettingProvider, child) => Column(
            children: [
              PageTitle(title: 'Your Settings'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: PiInfo(provider: userIdentityProvider),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: PiInfo(provider: userIdentityProvider),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: PiInfo(provider: userIdentityProvider),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(
                              height: 12,
                            ),
                            if (loading)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            AppColors.errorRed
                                                .withOpacity(0.6))),
                                    onPressed: () async {
                                      Future<void> deleteAccount() async {
                                        await authProvider.deleteAuthUser(
                                            authProvider.user?.id ?? '');
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             CustomMaterialApp()));
                                      }

                                      await showConfirmDialog(
                                          context,
                                          'Are you sure you want to delete your account?',
                                          deleteAccount);
                                    },
                                    child: Text('Delete Account',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          color: AppColors.black,
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            AppColors.purple.withOpacity(0.6))),
                                    onPressed: () async {
                                      Future<void> logout() async {
                                        await authProvider.logout();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomMaterialApp()));
                                      }

                                      await showConfirmDialog(
                                          context,
                                          'Are you sure you want to logout?',
                                          logout);
                                    },
                                    child: Text('Logout',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          color: AppColors.black,
                                          fontSize: 14,
                                        )),
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
            ],
          ),
        ),
      ),
    );
  }
}
