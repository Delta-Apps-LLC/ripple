import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton(
      {super.key,
      required this.text,
      required this.colors,
      this.icon,
      required this.function});
  final String text;
  final List<Color> colors;
  final Icon? icon;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton.icon(
        onPressed: function,
        label: Text(text,
            style: GoogleFonts.raleway(
                textStyle: TextStyle(color: AppColors.black, fontSize: 22))),
        style: buttonStyle,
        icon: icon,
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
