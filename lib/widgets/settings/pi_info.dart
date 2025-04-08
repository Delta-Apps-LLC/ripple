import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ripple/providers/auth_provider.dart';
import 'package:ripple/providers/user_identity_provider.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/misc/snackbar.dart';
import 'package:ripple/utils/modals/edit_pi_modal.dart';

class PiInfo extends StatefulWidget {
  const PiInfo({super.key, required this.provider});
  final UserIdentityProvider provider;

  @override
  State<PiInfo> createState() => _PiInfoState();
}

class _PiInfoState extends State<PiInfo> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final String? addressStr = widget.provider.person?.address?.formatAddress();
    final Map<String, String> piInfo = {
      "Name":
          "${widget.provider.person?.firstName} ${widget.provider.person?.lastName}",
      "Email": "${widget.provider.person?.email}",
      "Address": addressStr?.isEmpty == true ? 'None' : '$addressStr',
    };

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Information',
              style: GoogleFonts.montserrat(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
            IconButton(
              onPressed: () => showEditPiModal(context, widget.provider),
              icon: Icon(
                Icons.edit,
                size: 24,
              ),
              tooltip: 'Edit Info',
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(width: 2, color: AppColors.purple),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ...piInfo.keys.map(
                (key) => Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: GoogleFonts.lato(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        piInfo[key] ?? '',
                        style: GoogleFonts.lato(
                            color: AppColors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) => TextButton(
                      onPressed: () async {
                        setState(() => loading = true);
                        await authProvider.sendPasswordReset();
                        setState(() => loading = false);
                        showCustomSnackbar(
                            context,
                            'Password reset link sent to your email from "Supabase Auth"',
                            AppColors.green);
                      },
                      child: loading
                          ? CircularProgressIndicator(
                              color: AppColors.darkBlue,
                            )
                          : Text(
                              'Reset Password',
                              style: GoogleFonts.montserrat(
                                color: AppColors.black,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
