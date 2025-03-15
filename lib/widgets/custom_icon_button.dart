import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    super.key,
    required this.text,
    required this.colors,
    required this.function,
    this.icon,
    this.disabled = false,
  });
  final String text;
  final List<Color> colors;
  final VoidCallback function;
  final bool disabled;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: Container(
        width: 300,
        height: 50,
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
          onPressed: disabled ? null : function,
          label: Text(text,
              style: GoogleFonts.raleway(
                  textStyle: TextStyle(color: AppColors.black, fontSize: 22))),
          style: buttonStyle,
          icon: icon,
        ),
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
