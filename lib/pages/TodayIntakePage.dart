import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Configuration/Global.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';

class TodayIntakePage extends StatefulWidget {
  TodayIntakePage({Key? key}) : super(key: key);
  _TodayIntakePageState createState() => _TodayIntakePageState();
}

class _TodayIntakePageState extends PageStateTemplate {
  void loadTodaySugar() {
    try {
      String today = MyDateUtils.formatToyyyMMdd(DateTime.now());
      SharedPreferences.getInstance().then((prefs) {
        String alreadyTodaySugarIntake = "0";
        if (prefs.getString(PreferencesCfg.todaySugarIntake + today) != null) {
          alreadyTodaySugarIntake = prefs
              .getString(PreferencesCfg.todaySugarIntake + today)
              .toString();
        }
        TempData.todaySugarIntakeTotal.value =
            double.parse(alreadyTodaySugarIntake);
      });
    } catch (e) {
      Log.instance.e(e);
    }
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "Today's Intake",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
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
              "Content",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 36),
            )
          ],
        ),
      ],
    );
  }

  @override
  void specificInit() {
    loadTodaySugar();
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
