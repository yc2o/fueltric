
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWave extends StatefulWidget {
  final double height;
  final double speed;
  final double offset;
  final Color color;

  const AnimatedWave({
    super.key,
    required this.height,
    required this.speed,
    this.offset = 0.0,
    required this.color,
  });

  @override
  State<AnimatedWave> createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (5000 / widget.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            color: widget.color,
            animationValue: _controller.value,
            waveHeight: widget.height,
            offset: widget.offset,
          ),
          child: Container(),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double waveHeight;
  final double offset;
  final Color color;

  WavePainter({
    required this.animationValue,
    required this.waveHeight,
    required this.offset,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = offset * size.height;
    path.moveTo(0, y);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        y + math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * waveHeight,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}