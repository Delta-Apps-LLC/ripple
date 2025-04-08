import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/views/onboard.dart';
import 'package:ripple/widgets/misc/custom_icon_button.dart';
import 'package:ripple/widgets/structure/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('assets/images/ripple-logo-sm.png'),
                  Text(
                    'ripple',
                    style: GoogleFonts.montserrat(
                        color: AppColors.black, fontSize: 40),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                textAlign: TextAlign.center,
                'Making waves for good,\npennies at a time',
                style: GoogleFonts.lato(
                  color: AppColors.black,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
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
                        Navigator.pushReplacement(
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
                            textStyle: TextStyle(
                                color: AppColors.black, fontSize: 16)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: AppColors.black, fontSize: 16)),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
