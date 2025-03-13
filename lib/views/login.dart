import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/views/onboard.dart';
import 'package:ripple/widgets/custom_icon_button.dart';
import 'package:ripple/widgets/login_form.dart';

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
              ),
            ]),
            Column(
              children: [
                LoginForm(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGray,
                        thickness: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or',
                        style: GoogleFonts.raleway(
                            color: AppColors.black, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGray,
                        thickness: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomIconButton(
                    text: 'Sign up',
                    colors: [AppColors.lightGray, AppColors.lightGray],
                    icon: null,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnboardView()));
                    }),
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
