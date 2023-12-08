import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/userhead.jpeg'),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Hello Dean",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 36),
              )
            ],
          ),
          Column(
            children: [
              Column(
                children: [Text("Your", style: TextStyle(color: Colors.white))],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 74, 73, 73),
                  borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Current Daily Surgar Intake is",
                            style: TextStyle(color: Colors.white)),
                        CircleWidget(),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("60%", style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Row(
                          children: [
                            CustomProgressBar(
                              progress: 0.6,
                              color: Colors.orange,
                              height: 20,
                              width: 300,
                            ),
                            Text("10 g", style: TextStyle(color: Colors.green))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 74, 73, 73),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.red,
                      child: Text(
                        "1",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("Beverage", style: TextStyle(color: Colors.white)),
                    CustomProgressBar(
                      progress: 0.35,
                      color: Colors.blue,
                      height: 5,
                      width: 120,
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "35%",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 74, 73, 73),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.orange,
                      child: Text(
                        "2",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("Fruits", style: TextStyle(color: Colors.white)),
                    CustomProgressBar(
                      progress: 0.15,
                      color: Colors.blue,
                      height: 5,
                      width: 120,
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                      ),
                      child: Text(
                        "15%",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 74, 73, 73),
                  borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.yellow,
                      child: Text(
                        "3",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("Breads", style: TextStyle(color: Colors.white)),
                    CustomProgressBar(
                      progress: 0.1,
                      color: Colors.blue,
                      height: 5,
                      width: 120,
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                      ),
                      child: Text(
                        "10%",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '6 g',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;
  final double width;

  CustomProgressBar(
      {required this.progress,
      required this.color,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          width: width * progress,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
