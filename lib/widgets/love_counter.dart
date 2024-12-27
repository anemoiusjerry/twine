import 'package:flutter/material.dart';

class LoveCounter extends StatefulWidget {
  const LoveCounter({
    super.key,
    required this.anniversaryDate,
    this.colour = const Color(0xffFF78AE),
    this.borderColour = const Color(0xffFF008A),
    this.borderWidth = 0,
  });

  final DateTime anniversaryDate;
  final Color colour;
  final Color borderColour;
  final double borderWidth;

  @override
  State<LoveCounter> createState() => _LoveCounterState();
}

class _LoveCounterState extends State<LoveCounter> {
  // calculate time since 1st anniversary
  late Duration timeTogether;

  @override
  void initState() {
    super.initState();
    setState(() {
      timeTogether = DateTime.now().difference(widget.anniversaryDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 2),),
      child: CustomPaint(
      painter: _Painter(widget.colour, widget.borderColour, widget.borderWidth),
      size: const Size(150, 150),
      child: const SizedBox.square(
        dimension: 150, 
        child: Center(
          child: Text("50 days\n in love", textAlign: TextAlign.center)
        )
      ),
    ));
  }
}

class _Painter extends CustomPainter {
  _Painter(this.colour, this.borderColour, this.borderWidth);
  final Color colour;
  final Color borderColour;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Path path = Path();
       path.moveTo(0.5 * width, height * 0.35);
      path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
          0.5 * width, height);
      path.moveTo(0.5 * width, height * 0.35);
      path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
          0.5 * width, height);
          path.close();

    // Get the bounding box of the shape
    final Rect bounds = path.getBounds();

    // Translate canvas to collapse unused space
    canvas.translate(0, -bounds.top);

    final Paint body = Paint()
      ..color = colour
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    canvas.drawPath(path, body);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
