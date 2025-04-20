import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FancyBar extends StatelessWidget {
  final double height;
  final Color color;

  const FancyBar({super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 4.w,
      height: height,
      child: CustomPaint(painter: FancyBarPainter(color)),
    );
  }
}

class FancyBarPainter extends CustomPainter {
  final Color color;

  FancyBarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    double radius = size.width / 2;
    double notchRadius = size.width * 0.2;

    // Top round
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Side lines
    path.lineTo(size.width, size.height - notchRadius);
    path.quadraticBezierTo(size.width * 0.75, size.height, radius, size.height);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      0,
      size.height - notchRadius,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
