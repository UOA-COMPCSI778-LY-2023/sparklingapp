import 'package:flutter/material.dart';

// Abstract factory interface
abstract class FloatingActionButtonFactory {
  FloatingActionButtonLocation createLocation();
  FloatingActionButtonAnimator createAnimator();
}

// Concrete factory for CustomFloatingActionButton
class CustomFloatingActionButtonFactory implements FloatingActionButtonFactory {
  final double offsetX;
  final double offsetY;
  final FloatingActionButtonLocation abLocation;

  CustomFloatingActionButtonFactory(
      this.abLocation, this.offsetX, this.offsetY);

  @override
  CustomFloatingActionButtonLocation createLocation() {
    // Providing a standard FloatingActionButtonLocation instance
    return CustomFloatingActionButtonLocation(abLocation, offsetX, offsetY);
  }

  @override
  scalingAnimation createAnimator() {
    return scalingAnimation();
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class scalingAnimation extends FloatingActionButtonAnimator {
  late double _x;
  late double _y;
  @override
  Offset getOffset({Offset? begin, Offset? end, required double progress}) {
    _x = begin!.dx + (end!.dx - begin.dx) * progress;
    _y = begin.dy + (end.dy - begin.dy) * progress;
    return Offset(_x, _y);
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}

class barBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue, // 设置为你想要的蓝色背景
        borderRadius: BorderRadius.all(Radius.circular(15)), // 设置圆角的半径
      ),
      margin: EdgeInsets.all(8), // 可以调整外边距，使按钮不会贴近边缘
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white), // 设置图标颜色为白色
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
