import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Business/GetIntakeListLastWeek.dart';
import '../Configuration/APIList.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../interface/PageStateTemplate.dart';
import 'ErrorPage.dart';
import 'ProductDetailPage.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends PageStateTemplate {
  List<dynamic> intakeListLastWeek = [];
  
  @visibleForTesting
  void setMockData(List<dynamic> mockData) {
    intakeListLastWeek = mockData;
  }

  Future<void> getIntakeListLastWeek() async {
    try {
      String api = APIList.lightSugarAPI["getIntakeListLastWeek"];
      GetIntakeListLastWeek getIntakeListLastWeek = GetIntakeListLastWeek();
      Response response = await MyHttpRequest.instance
          .sendRequest(api, {}, getIntakeListLastWeek);
      if (response.data["ack"] == "success") {
        setState(() {
          intakeListLastWeek = response.data['list'].reversed.toList();
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

  @override
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "Intake History",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
    Divider(color: Colors.white);
    return Column(
      children: <Widget>[
        Divider(color: Color.fromRGBO(43, 43, 43, 1), thickness: 2),
        SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: intakeListLastWeek.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              var record = intakeListLastWeek[index]['food'];
              return InkWell(  
                onTap: () { 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                          productDetailData: record),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(58, 58, 58, 1),
                    borderRadius: BorderRadius.circular(10), 
                    boxShadow: [
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10)),
                            child: Image.network(
                              record['img_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12), // Add space between image and text
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  record['product_name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(  
                                    Icons.arrow_forward_ios,  
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void specificInit() {
    getIntakeListLastWeek();
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
