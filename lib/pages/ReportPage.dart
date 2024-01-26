import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Business/Get7DaysAverage.dart';
import '../Configuration/APIList.dart';
import '../Configuration/Global.dart';
import '../components/CustomBarChat.dart';
import '../components/DataUtils.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends PageStateTemplate {
  List<double> reportData = [];
  List<String> reportLabel = [];
  List originalReport = [];

  Future<void> get7DaysAverage() async {
    try {
      String api = APIList.lightSugarAPI["get7daysSugar"];
      // 使用 ConcreteHandlerA 发送请求
      Get7DaysAverage getProductInfoFromOpenFood = Get7DaysAverage();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getProductInfoFromOpenFood);
      if (response.data["ack"] == "success") {
        setState(() {
          originalReport = response.data['report'];
          if (originalReport.length > 0) {
            originalReport.forEach((item) {
              reportData.add(item["sugarIntake"].toDouble());
              reportLabel.add(DataUtils.getDayFromDateString(item["date"]));
            });
          }
          double totalSum = 0;
          reportData.forEach((rData) {
            totalSum = totalSum + rData;
          });
          TempData.average7DaysSugar.value = totalSum / reportData.length;
        });
      } else if (response.data["ack"] == "failure" &&
          response.data["message"] != null) {
        Toast.toast(context,
            msg: "${response.data["message"]}", position: ToastPostion.bottom);
      }
    } catch (e) {
      Toast.toast(context,
          msg: "${e.toString()}", position: ToastPostion.bottom);
    }
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "Sugar Intake Report",
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
    String strToday = MyDateUtils.formatToddMMyyy(DateTime.now());
    String str7DaysAgo = "";
    if (originalReport.length > 0) {
      strToday = MyDateUtils.formatToddMMyyy(
          DateTime.parse(originalReport[originalReport.length - 1]["date"]));
      str7DaysAgo =
          DateTime.parse(originalReport[originalReport.length - 1]["date"])
              .add(Duration(days: -7))
              .day
              .toString();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            ValueListenableBuilder<double>(
                valueListenable: TempData.average7DaysSugar,
                builder: (c, ac, _) {
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
                            Text("You sugar intake 7-days average",
                                style: TextStyle(color: Colors.white)),
                            CircleWidget(),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            str7DaysAgo + " - " + strToday,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        originalReport.length > 0
            ? CustomBarChart(
                data: reportData,
                labels: reportLabel,
                title: '${reportData[reportData.length - 1]} grams',
                subTitle: strToday,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 74, 73, 73),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            : Text("no data")
      ],
    );
  }

  @override
  void specificInit() {
    get7DaysAverage();
  }
}

class CircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: TempData.average7DaysSugar,
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
