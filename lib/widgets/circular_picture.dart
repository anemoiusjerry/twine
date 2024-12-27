import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key, 
    required this.child, 
    this.borderColour = Colors.white, 
    this.backgroundColour = Colors.white,
    this.radius = 100, 
    this.borderWidth = 5
  });

  final double radius;
  final double borderWidth;
  final Color borderColour;
  final Color backgroundColour;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: borderColour),
        color: backgroundColour
      ),
      child: ClipOval(
        child: child
      )
    );
  }
}