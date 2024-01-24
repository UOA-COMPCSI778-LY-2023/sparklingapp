import 'package:flutter/material.dart';

class NumberAdjuster extends StatefulWidget {
  int minNumber;
  int maxNumber;
  final int initialValue;
  final ValueChanged<int> onValueChanged;
  NumberAdjuster(
      {Key? key,
      required this.minNumber,
      required this.maxNumber,
      required this.initialValue,
      required this.onValueChanged})
      : super(key: key);
  @override
  _NumberAdjusterState createState() =>
      _NumberAdjusterState(minNumber: minNumber, maxNumber: maxNumber);
}

class _NumberAdjusterState extends State<NumberAdjuster> {
  int _currentValue = 0;
  int minNumber;
  int maxNumber;

  _NumberAdjusterState({required this.minNumber, required this.maxNumber});

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    setState(() {
      if (_currentValue < maxNumber) _currentValue++;
    });
    widget.onValueChanged(_currentValue);
  }

  void _decrement() {
    setState(() {
      if (_currentValue > minNumber) _currentValue--;
    });
    widget.onValueChanged(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.orange,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Text(
              '$_currentValue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: -3,
          bottom: 0,
          child: IconButton(
            color: Colors.black,
            icon: Icon(Icons.remove, size: 20),
            onPressed: _decrement,
          ),
        ),
        Positioned(
          right: 0,
          top: -3,
          bottom: 0,
          child: IconButton(
            color: Colors.black,
            icon: Icon(Icons.add, size: 20),
            onPressed: _increment,
          ),
        ),
      ],
    );
  }
}
