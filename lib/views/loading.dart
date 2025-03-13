import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset('assets/images/ripple-logo-sm.png'),
                Text(
                  'ripple',
                  style: GoogleFonts.montserrat(
                      color: AppColors.black, fontSize: 40),
                ),
                const SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  color: AppColors.darkBlue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
