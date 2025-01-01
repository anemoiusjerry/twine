import 'dart:math';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:twine/styles/colours.dart';
import 'package:twine/widgets/countdown_timer.dart';

class DonutData {
  const DonutData(this.colour, this.percent);
  final Color colour;
  final double percent;
}

// Draws a 2 segment pie chart with text in the hollow center. It includes
// a countdown timer and date picking functionality to send target date.
class CountdownDonut extends StatefulWidget {
  // constructor shorthand
  const CountdownDonut({
    super.key,
    this.radius = 60,
    this.strokeWidth = 12,
    this.voidColour = AppColours.gray,
    this.highlightColour = AppColours.secondary,
    required this.reunionDate,
    required this.separationDate,
  });

  // size of the donut
  final double radius;
  // thickness of the donut
  final double strokeWidth;
  final Color voidColour;
  final Color highlightColour;
  final DateTime reunionDate;
  final DateTime separationDate;

  @override
  State<CountdownDonut> createState() => _CountdownDonutState();
}

class _CountdownDonutState extends State<CountdownDonut> {
  late List<DonutData> slices;
  late int timeToReunion;
  late int timeApart;

  @override
  void initState() {
    super.initState();
    timeToReunion = widget.reunionDate.difference(widget.separationDate).inDays;
    timeApart = DateTime.now().difference(widget.separationDate).inDays;
    double percentageApart = 100 * (timeToReunion == 0 ? 1 : timeApart/timeToReunion);
    
    slices = [
      // highlight the time edured apart
      DonutData(widget.highlightColour, percentageApart),
      DonutData(widget.voidColour, 100-percentageApart)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context, 
          bodyBuilder: (context) => CountdownTimer(endTime: widget.reunionDate),
          direction: PopoverDirection.top,
          arrowDyOffset: -20
        );
      },
      child: CustomPaint(
        painter: _Painter(widget.strokeWidth, slices),
        size: Size.square(widget.radius),
        child: SizedBox.square(
          dimension: 2*widget.radius,
          child: Center(
            child: Text("${timeToReunion - timeApart} days left"),
          )
        )
      ),
    );
  }
}

class _PainterData {
  const _PainterData(this.paint, this.radians);
  final Paint paint;
  final double radians;
}

class _Painter extends CustomPainter {
  _Painter(double strokeWidth, List<DonutData> slices) {
    // init paint settings and convert to radians
    dataList = slices.map((e) => _PainterData(
      Paint()
        ..color = e.colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
        (e.percent - _percentPadding) * _percentRadians,
    )).toList();
  }

  static const _percentPadding = 5;
  static const _percentRadians = 2*pi / 100;
  late final List<_PainterData> dataList;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // change angle to rotate starting point
    double startAngle = -180 * 2*pi/360;

    for (final data in dataList) {
      final path = Path()..addArc(rect, startAngle, data.radians);
      // shift start angle for next draw
      startAngle += data.radians + _percentPadding * _percentRadians;
      canvas.drawPath(path, data.paint); 
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}