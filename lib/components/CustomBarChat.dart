import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final String title;
  final String subTitle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;

  CustomBarChart({
    required this.data,
    required this.labels,
    required this.title,
    required this.subTitle,
    required this.padding,
    required this.margin,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth - margin.horizontal;

    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(
                constraints.maxWidth, (constraints.maxWidth * 0.6).toDouble()),
            painter: BarChartPainter(
              data: data,
              labels: labels,
              title: title,
              subTitle: subTitle,
              barWidth: constraints.maxWidth /
                  (data.length * 2.5), // Adjust the bar width here
            ),
          );
        },
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  BarChartPainter({
    required this.barWidth,
    required this.data,
    required this.labels,
    required this.title,
    required this.subTitle,
  });

  final double barWidth;
  final List<double> data;
  final List<String> labels;
  final String title;
  final String subTitle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final labelStyle = TextStyle(color: Colors.white, fontSize: 12);
    final titleStyle = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
    final subTitleStyle = TextStyle(color: Colors.white70, fontSize: 12);

    // Draw the background
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.color = Color.fromARGB(255, 74, 73, 73);
    canvas.drawRect(rect, paint);

    // Draw the grid lines and the grid labels
    paint.color = Color(0xff37434d);
    paint.strokeWidth = 1;
    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    double gridLineHeight = size.height - 30; // height for grid lines
    double gridStep = gridLineHeight / 4; // number of grid lines

    for (int i = 0; i <= 4; i++) {
      double y = gridStep * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      // Draw grid labels
      String gridLabel =
          '${((4 - i) * 50).toInt()}'; // assuming max value is 200
      final span = TextSpan(style: labelStyle, text: gridLabel);
      final tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          Offset(size.width - 20,
              y - tp.height / 2 - 10)); // Center the grid label vertically
    }

    // Draw the bars
    double maxData = data.reduce((a, b) => a > b ? a : b);
    double totalBarWidth = barWidth * data.length;
    double totalSpacingWidth = size.width - totalBarWidth;
    double barSpacing = totalSpacingWidth / (data.length + 1);

    // radius = Radius.circular(20);

    for (int i = 0; i < data.length; i++) {
      double left = barSpacing + i * (barWidth + barSpacing);
      double top = size.height - (size.height * (data[i] / maxData));
      double right = left + barWidth;
      double bottom = size.height - 30;

      // Draw each rounded bar
      paint.color = Colors.red;

      double radiusNumber = (data[i] > 20) ? 20 : data[i];
      Radius radius = Radius.circular(radiusNumber);

      // if (data[i] > 0) {
      if (top < bottom) {
        RRect roundedRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(left, top, right, bottom),
          topLeft: radius,
          topRight: radius,
          bottomRight: radius,
          bottomLeft: radius,
        );
        canvas.drawRRect(roundedRect, paint);
      }
      // } else {
      //   // canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
      // }

      // Draw labels
      final span = TextSpan(style: labelStyle, text: labels[i]);
      final tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(left + (barWidth / 2) - (tp.width / 2), size.height - 20));
    }

    // Draw the title and subtitle
    final titleSpan = TextSpan(style: titleStyle, text: title);
    final titleTp = TextPainter(
        text: titleSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    titleTp.layout();
    titleTp.paint(canvas, Offset(0, -20));

    final subTitleSpan = TextSpan(style: subTitleStyle, text: subTitle);
    final subTitleTp = TextPainter(
        text: subTitleSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    subTitleTp.layout();
    subTitleTp.paint(canvas, Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
