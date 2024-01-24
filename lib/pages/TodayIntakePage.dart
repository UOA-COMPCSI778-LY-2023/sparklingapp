import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sugatiol/components/CommonBizLogic.dart';
import '../Business/RemoveSugarIntake.dart';
import '../Configuration/APIList.dart';
import '../Configuration/Global.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';
import 'ErrorPage.dart';
import 'ProductDetailPage.dart';

class TodayIntakePage extends StatefulWidget {
  TodayIntakePage({Key? key}) : super(key: key);
  _TodayIntakePageState createState() => _TodayIntakePageState();
}

class _TodayIntakePageState extends PageStateTemplate {
  

  // Future<void> listSugarIntakesToday() async {
  //   try {
  //     String api = APIList.lightSugarAPI["listSugarIntakesToday"];
  //     ListSugarIntakesToday listSugarIntakesToday = ListSugarIntakesToday();
  //     Response response = await MyHttpRequest.instance
  //         .sendRequest(api, {}, listSugarIntakesToday);
  //     if (response.data["ack"] == "success") {
  //       setState(() {
  //         intakeListToday = response.data['list'];
  //       });
  //     } else if (response.data["ack"] == "failure") {
  //       Toast.toast(context,
  //           msg: "Fail to get Intake List.", position: ToastPostion.bottom);
  //     }
  //   } catch (e) {
  //     Log.instance.e(e);
  //   }
  // }

  Future<void> removeSugarIntake(String recordId) async {
    Map<String, dynamic> parameters = {
      "username": "jnz121",
      "record_id": recordId
    };

    try {
      String api = APIList.lightSugarAPI["removeSugarIntake"];
      RemoveSugarIntake removeSugarIntake = RemoveSugarIntake(parameters);
      Response response = await MyHttpRequest.instance
          .sendRequest(api, parameters, removeSugarIntake);

      if (response.data["ack"] == "success") {
        await CommonBizLogic.getIntakeListToday();
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
        "Today's Intake",
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

    return ValueListenableBuilder<List>(
        valueListenable: TempData.intakeListToday,
        builder: (c, ac, _) {
          return Column(
            children: <Widget>[
              Divider(color: Color.fromRGBO(43, 43, 43, 1), thickness: 2),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: ac.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var item = ac[index];
                    return Slidable(
                      key: ValueKey(item['_id']),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              removeSugarIntake(item['_id']);
                              double sugarsServing = (item['food']['nutriments']
                                      ['sugars_serving'] as num)
                                  .toDouble();
                              double sugarDelete =
                                  sugarsServing * item['serving_count'];
                              TempData.todaySugarIntakeTotal.value =
                                  TempData.todaySugarIntakeTotal.value -
                                      sugarDelete;
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                productDetailData: item['food'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(58, 58, 58, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: Image.network(
                                  item['food']['img_url'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item['food']['product_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Serving Qty: ${item['serving_count']}',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ],
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
        });
  }

  @override
  Future<void> specificInit() async {
    CommonBizLogic.getIntakeListToday();
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
