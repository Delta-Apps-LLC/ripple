import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple/themes.dart';
import 'package:ripple/utils/modals/stat_info_modal.dart';

class AnimatedProgressWave extends StatefulWidget {
  const AnimatedProgressWave({
    super.key,
    this.value = 0.0,
    required this.threshold,
  });
  final double value;
  final int threshold;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
      child: Container(
        width: 120,
        height: 120,
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
                  percentage: (widget.value / widget.threshold).clamp(0.0, 1.0),
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
                              color: AppColors.black, fontSize: 22),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.darkBlue,
                            size: 30,
                          ),
                          onPressed: () => showInfoModal(
                              context,
                              '\$${widget.value.toStringAsFixed(2)}',
                              'This is how much you have currently rounded up towards your next donation of \$${widget.threshold}'),
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
