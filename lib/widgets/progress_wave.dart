import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';

class AnimatedProgressWave extends StatefulWidget {
  final double value;

  const AnimatedProgressWave({super.key, required this.value});

  @override
  _AnimatedProgressWaveState createState() => _AnimatedProgressWaveState();
}

class _AnimatedProgressWaveState extends State<AnimatedProgressWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'What does this mean?',
                    style: GoogleFonts.lato(
                      color: AppColors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${widget.value.toStringAsFixed(2)}',
                    style: GoogleFonts.montserrat(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This is how much you have currently rounded up towards your next donation of \$5',
                    style:
                        GoogleFonts.lato(color: AppColors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.montserrat(
                          color: AppColors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _WavePainter(
                  percentage: (widget.value / 5.0).clamp(0.0, 1.0),
                  wavePhase: _controller.value * 2 * pi,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${(widget.value).toStringAsFixed(2)}',
                          style: GoogleFonts.montserrat(
                              color: AppColors.black, fontSize: 26),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.darkBlue,
                            size: 35,
                          ),
                          onPressed: () => showInfoModal(context),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double percentage;
  final double wavePhase;

  _WavePainter({required this.percentage, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw Background Circle
    final backgroundPaint = Paint()
      ..color = AppColors.lightGray
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Wave settings
    final fillHeight = size.height * (1 - percentage);
    final waveHeight = 8.0;
    final waveLength = size.width * 0.75;

    Path wavePath = Path();
    wavePath.moveTo(0, size.height);

    // Generate a smooth wave
    for (double x = 0; x <= size.width; x += 1) {
      double y =
          fillHeight + waveHeight * sin((x / waveLength) * 2 * pi + wavePhase);
      wavePath.lineTo(x, y);
    }

    // Extend path downwards to fully cover the bottom
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // Wave fill paint
    final wavePaint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.fill;
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.wavePhase != wavePhase;
  }
}
