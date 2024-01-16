import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Business/GetSugarIntakeToday.dart';

import '../Configuration/APIList.dart';
import '../Configuration/Global.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageStateTemplate {
  Future<void> getSugarIntakeToday() async {
    try {
      String api = APIList.lightSugarAPI["getSugarIntakeToday"];
      GetSugarIntakeToday getSugarIntakeToday = GetSugarIntakeToday();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getSugarIntakeToday);

      if (response.data["ack"] == "success") {
        double sugarToday = (response.data['sugarToday'] as num).toDouble();
        TempData.todaySugarIntakeTotal.value = sugarToday;
      }
    } catch (e) {
      Log.instance.e(e);
    }
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "Home",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      centerTitle: false,
      elevation: 0,
      actions: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/userhead.jpeg'),
        ),
      ],
    );
  }

  @override
  Widget buildPageBody() {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
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
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Text("Today",
                    style: TextStyle(color: Colors.white, fontSize: 24))
              ],
            ),
            ValueListenableBuilder<double>(
                valueListenable: TempData.todaySugarIntakeTotal,
                builder: (c, ac, _) {
                  double targetSugarNum = 100;
                  double currentSugarRate = 0;
                  if (targetSugarNum > 0) {
                    currentSugarRate = (TempData.todaySugarIntakeTotal.value /
                            targetSugarNum) *
                        100;
                  }
                  if (currentSugarRate > 100) {
                    currentSugarRate = 100;
                  }
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 74, 73, 73),
                      borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Text("${currentSugarRate}%",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomProgressBar(
                                  progress: currentSugarRate / 100,
                                  color: currentSugarRate > 80
                                      ? Colors.red
                                      : currentSugarRate > 50
                                          ? Colors.orange
                                          : Colors.green,
                                  height: 20,
                                  width: 250,
                                ),
                                Text("${targetSugarNum} g",
                                    style: TextStyle(color: Colors.green))
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                })
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
    );
  }

  @override
  void specificInit() {
    getSugarIntakeToday();
  }
}

class CircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: TempData.todaySugarIntakeTotal,
        builder: (c, ac, _) {
          String showNum = "0";
          if (ac > 999) {
            showNum = "999+";
          } else {
            showNum = ac.round().toString();
          }
          return Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${showNum} g',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        });
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
