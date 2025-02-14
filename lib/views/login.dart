import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/widgets/custom_icon_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Image.asset('assets/images/ripple-logo-sm.png'),
              Text(
                'ripple',
                style: GoogleFonts.montserrat(
                    color: AppColors.black, fontSize: 40),
              )
            ]),
            Column(
              children: [
                CustomIconButton(
                    text: 'Sign in with Email',
                    colors: [AppColors.lightGray, AppColors.purple],
                    icon: Icon(
                      Icons.key,
                      size: 35,
                      color: AppColors.green,
                    ),
                    function: () {}),
                const SizedBox(
                  height: 15,
                ),
                CustomIconButton(
                    text: 'Sign up',
                    colors: [AppColors.lightGray, AppColors.purple],
                    icon: null,
                    function: () {}),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Text(
                      'Terms and Conditions',
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: AppColors.black, fontSize: 16)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Privacy Policy',
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: AppColors.black, fontSize: 16)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
