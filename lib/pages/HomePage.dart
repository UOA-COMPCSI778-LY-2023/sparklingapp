import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sugatiol/components/CommonBizLogic.dart';
import '../Business/AddSugarIntake.dart';
import '../Business/GetIntakePrediction.dart';
import '../Business/GetPredictionbymodel.dart';
import '../Business/GetSugarIntakeToday.dart';
import '../Business/GetSugarTarget.dart';
import '../Configuration/APIList.dart';
import '../Configuration/Global.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';
import 'ErrorPage.dart';
import 'IntakeLimitEditPage.dart';
import 'OneClickConfirmPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageStateTemplate {
  double targetSugarNum = 100;
  List<dynamic> predictionFood = [];
  bool _showFrequent = true;

  @override
  void specificInit() {}

  @override
  void initState() {
    super.initState();
    getSugarTarget();
    getSugarIntakeToday();
    getIntakePrediction();
  }

  Future<void> getSugarTarget() async {
    try {
      String api = APIList.lightSugarAPI["getSugarTarget"];
      GetSugarTarget getSugarTarget = GetSugarTarget();
      Response response =
          await MyHttpRequest.instance.sendRequest(api, {}, getSugarTarget);
      if (response.data["ack"] == "success") {
        double sugarTarget = (response.data['sugarTarget'] as num).toDouble();
        setState(() {
          targetSugarNum = sugarTarget;
        });
      } else if (response.data["ack"] == "failure") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ErrorPage(errorMessage: response.data["message"])),
        );
      }
    } catch (e) {
      Log.instance.e(e);
    }
  }

  Future<void> getSugarIntakeToday() async {
    try {
      String api = APIList.lightSugarAPI["getSugarIntakeToday"];
      GetSugarIntakeToday getSugarIntakeToday = GetSugarIntakeToday();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getSugarIntakeToday);

      if (response.data["ack"] == "success") {
        double sugarToday = (response.data['sugarToday'] as num).toDouble();
        TempData.todaySugarIntakeTotal.value = sugarToday;
      } else if (response.data["ack"] == "failure") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ErrorPage(errorMessage: response.data["message"])),
        );
      }
    } catch (e) {
      Log.instance.e(e);
    }
  }

  Future<void> getIntakePrediction() async {
    try {
      if (_showFrequent) {
        String api = APIList.lightSugarAPI["getIntakePrediction"];
        GetIntakePrediction getIntakePrediction = GetIntakePrediction();
        Response response = await MyHttpRequest.instance
            .sendRequest(api, {}, getIntakePrediction);
        if (response.data["ack"] == "success") {
          setState(() {
            predictionFood = response.data['predictions'];
          });
        } else if (response.data["ack"] == "failure" &&
            response.data["message"] ==
                "No food data available for this time interval.") {
          predictionFood = [];
        }
      } else {
        String api = APIList.lightSugarAPI["getPredictionbymodel"];
        GetPredictionByModel getPredictionByModel = GetPredictionByModel();
        Response response = await MyHttpRequest.instance
            .sendRequest(api, {}, getPredictionByModel);
        if (response.data["ack"] == "success") {
          setState(() {
            predictionFood = response.data['predictions'];
          });
        } else if (response.data["ack"] == "failure") {
          predictionFood = [];
        }
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
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today",
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IntakeLimitEditPage(
                                sugarTarget: targetSugarNum)),
                      );
                    },
                    child: Text("Set Target",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<double>(
                valueListenable: TempData.todaySugarIntakeTotal,
                builder: (c, ac, _) {
                  double currentSugarRate = 0;
                  if (targetSugarNum > 0) {
                    currentSugarRate = double.parse(
                        ((TempData.todaySugarIntakeTotal.value /
                                    targetSugarNum) *
                                100)
                            .toStringAsFixed(2));
                  }
                  if (currentSugarRate > 100) {
                    currentSugarRate = 100;
                  }
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 74, 73, 73),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Current Daily Surgar Intake ",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
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
        _buildTabBar(),
        // Use Flexible to make the ListView scrollable within the column
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: predictionFood.length,
            itemBuilder: (context, index) {
              var item = predictionFood[index]['food'];
              return Card(
                // Wrap each item in a Card
                elevation:
                    2.0, // Adjust the elevation as needed to match design
                color: Color.fromARGB(255, 74, 73, 73),
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(item['img_url']),
                  ),
                  title: Text(item['product_name'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  subtitle: Text(
                    "Servings: ${predictionFood[index]['mostFrequentServingCount']} ${predictionFood[index]['food']['serving_qty_unit']}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white, // Add button to increment the serving
                    onPressed: () async {
                      try {
                        await CommonBizLogic.addSugarIntake(
                            predictionFood[index]['food']['code'],
                            predictionFood[index]['mostFrequentServingCount']);
                        await CommonBizLogic.getIntakeListToday();
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OneClickConfirmPage(
                                    msg: "Sugar Intake added!")));
                      } catch (e) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ErrorPage(errorMessage: e.toString())),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _showFrequent = true;
                  getIntakePrediction();
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _showFrequent ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Frequent Intake',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _showFrequent = false;
                  getIntakePrediction();
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !_showFrequent ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Recommended',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
