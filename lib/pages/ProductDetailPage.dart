import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Configuration/Global.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/Toast.dart';

class ProductDetailPage extends StatefulWidget {
  final Map productDetailData;
  ProductDetailPage({Key? key, required this.productDetailData})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState(productDetailData: this.productDetailData);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final Map productDetailData;
  _ProductDetailPageState({required this.productDetailData});
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
      if (contentHeight < 60) contentHeight = 60;

      final size = MediaQuery.of(context).size;

      String imgUrl = "";
      if (productDetailData["image_front_url"] != null) {
        imgUrl = productDetailData["image_front_url"];
      }
      List ingridientsList = [];
      if (productDetailData["ingredients"] != null) {
        ingridientsList = productDetailData["ingredients"];
      }
      Map nutriments = {};
      if (productDetailData["nutriments"] != null) {
        nutriments = productDetailData["nutriments"];
      }
      double sugarNum = 0;
      if (nutriments["sugars"] != null) {
        sugarNum = double.parse(nutriments["sugars"].toString());
      }
      int sugarCubs = (sugarNum / 4.5).ceil();

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Scan Result",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: 200,
                      width: size.width - 20,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 81, 136),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: sugarCubs,
                        itemBuilder: (context, index) {
                          return Image(
                            image: AssetImage("assets/deployed_code.png"),
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 74, 73, 73),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_alarm,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              "${productDetailData["product_name"]} contains ${sugarNum.toStringAsFixed(2)}g sugar, equals to ${(sugarNum / 4.5).toStringAsFixed(2)} sugar cubes",
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Product Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 74, 73, 73),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1, // 占用可用空间的1份
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // color: Colors.red,
                              // height: 100,
                              child: Center(
                                child: (imgUrl == "")
                                    ? Image(
                                        image: AssetImage(
                                            "assets/product_no_found.png"))
                                    : Image.network(imgUrl),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2, // 占用可用空间的2份
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              alignment: Alignment.topCenter,
                              child: Text(
                                productDetailData["product_name"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ingridientsList.length > 0)
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nutrition Table",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Per Serving",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    if (ingridientsList.length > 0)
                      Container(
                        height: ingridientsList.length * 30 + 5,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 74, 73, 73),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          itemCount: ingridientsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String strAmount = "";
                            strAmount = ingridientsList[index]
                                    ["percent_estimate"]
                                .toString();
                            if (strAmount != "") {
                              double amount = double.parse(strAmount);
                              strAmount = amount.toStringAsFixed(1);
                            }
                            return Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              height: 25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ingridientsList[index]["text"],
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      strAmount + " g",
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    // Container(
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   alignment: Alignment.bottomLeft,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "Nutriments Table",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       Text(
                    //         "Per Serving",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   height: nutriments.keys.toList().length * 30 + 5,
                    //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    //   decoration: BoxDecoration(
                    //     color: Color.fromARGB(255, 74, 73, 73),
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   child: ListView.builder(
                    //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //     itemCount: nutriments.keys.toList().length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Container(
                    //         margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    //         height: 25,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               nutriments.keys.toList()[index],
                    //               style: TextStyle(color: Colors.white),
                    //             ),
                    //             Text(
                    //               nutriments[nutriments.keys.toList()[index]]
                    //                       .toString() +
                    //                   " g",
                    //               style: TextStyle(color: Colors.white),
                    //             )
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                // color: const Color.fromARGB(255, 110, 109, 109),
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            String today =
                                MyDateUtils.formatToyyyMMdd(DateTime.now());
                            SharedPreferences.getInstance().then((prefs) {
                              String alreadyTodaySugarIntake = "0";
                              if (prefs.getString(
                                      PreferencesCfg.todaySugarIntake +
                                          today) !=
                                  null) {
                                alreadyTodaySugarIntake = prefs
                                    .getString(
                                        PreferencesCfg.todaySugarIntake + today)
                                    .toString();
                              }
                              double todaySugarIntakeTotal =
                                  double.parse(alreadyTodaySugarIntake) +
                                      sugarNum;
                              prefs.setString(
                                  PreferencesCfg.todaySugarIntake + today,
                                  todaySugarIntakeTotal.toString());
                              TempData.todaySugarIntakeTotal.value =
                                  todaySugarIntakeTotal;
                            });
                            Navigator.pop(context);
                          } catch (e) {
                            Log.instance.e(e);
                            Toast.toast(context,
                                msg: "${e.toString()}",
                                position: ToastPostion.bottom);
                          }
                        },
                        child:
                            Text('Add', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } catch (e) {
      Log.instance.e(e);
      return Scaffold(body: Text(e.toString()));
    }
  }
}
