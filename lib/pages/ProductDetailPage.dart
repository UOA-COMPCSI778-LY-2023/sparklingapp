import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugatiol/components/CommonBizLogic.dart';
import 'package:sugatiol/components/DataUtils.dart';

import '../Configuration/Global.dart';
import '../components/Button.dart';
import '../components/DateUtils.dart';
import '../components/LogUtils.dart';
import '../components/NumberAdjuster.dart';
import '../components/Toast.dart';
import '../interface/PageStateTemplate.dart';
import 'OneClickConfirmPage.dart';

class ProductDetailPage extends StatefulWidget {
  final Map productDetailData;
  ProductDetailPage({Key? key, required this.productDetailData})
      : super(key: key);

  @override
  _ProductDetailPageState createState() =>
      _ProductDetailPageState(productDetailData: this.productDetailData);
}

class _ProductDetailPageState extends PageStateTemplate {
  final Map productDetailData;
  _ProductDetailPageState({required this.productDetailData});
  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Scan Result",
        style: TextStyle(color: Colors.white),
      ),
      leading: barBackButton(),
    );
  }

  @override
  Widget buildPageBody() {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;

    final size = MediaQuery.of(context).size;

    String imgUrl = "";
    if (productDetailData["img_url"] != null) {
      imgUrl = productDetailData["img_url"];
    }
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
    Map nutrimentsServing = {};
    nutriments.keys.forEach((element) {
      if (!element.toString().contains("_unit")) {
        String strValue = nutriments[element].toString();
        if (strValue != "") {
          double amount = double.parse(strValue);
          strValue = amount.toStringAsFixed(1);
        }
        String strUnit = "";
        if (nutriments[element + "_unit"] != null) {
          strUnit = " " + nutriments[element + "_unit"];
        }
        String finalValue = strValue + strUnit;
        nutrimentsServing[element] = finalValue;
      }
    });
    double sugarNum = 0;
    double sugarTotal = 0;
    if (nutriments["Sugars"] != null) {
      sugarTotal = nutriments["Sugars"] *
          double.parse(productDetailData['serving_per_pack'].toString());
      sugarNum = double.parse(sugarTotal.toString());
    }
    if (nutriments["sugars"] != null) {
      sugarTotal = nutriments["sugars"] * 1.0;
      //double.parse(productDetailData['rev'].toString());
      sugarNum = double.parse(sugarTotal.toString());
    }
    int sugarCubs = (sugarNum / 4.5).ceil();

    int qtyNumber = productDetailData["serving_qty"] ?? 1;
    double qtyPer = double.parse((productDetailData["nutriments"]["Sugars"] ??
            productDetailData["nutriments"]["sugars"])
        .toString());

    ValueNotifier<double> qtyValue = ValueNotifier(qtyNumber * 1.0);

    void _handleValueChanged(int newValue) {
      qtyNumber = newValue;
      qtyValue.value = qtyPer * qtyNumber;
    }

    return Stack(
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
                    color: const Color.fromARGB(255, 74, 73, 73),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: sugarCubs,
                    itemBuilder: (context, index) {
                      return Image(
                        image: AssetImage("assets/spoon.jpeg"),
                        //color: Colors.white,
                        width: 10,
                        height: 10,
                      );
                    },
                  ),
                ),
                Container(
                  //height: 400 - 40,
                  //right: 40,
                  margin: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      "Total sugar ${sugarNum} g",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
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
                          "${productDetailData["product_name"]} equals to ${(sugarNum / 4.5).toStringAsFixed(2)} tea spoons of sugar",
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
                            style: TextStyle(color: Colors.white, fontSize: 24),
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
                          "Ingridients Table",
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
                        strAmount = ingridientsList[index]["percent_estimate"]
                            .toString();
                        if (strAmount != "") {
                          double amount = double.parse(strAmount);
                          strAmount = amount.toStringAsFixed(1);
                        }
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 74, 73, 73),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Serving Qty",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        NumberAdjuster(
                          minNumber: productDetailData["serving_qty"] ?? 1,
                          maxNumber: productDetailData["serving_per_pack"] ?? 1,
                          initialValue: qtyNumber,
                          onValueChanged: _handleValueChanged,
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Serving Size",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          ValueListenableBuilder<double>(
                              valueListenable: qtyValue,
                              builder: (c, ac, _) {
                                return Text(
                                  ac.toString() +
                                      " " +
                                      (productDetailData["serving_qty_unit"] ??
                                          "g"),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                );
                              }),
                        ])
                  ]),
                ),
                if (nutrimentsServing.keys.length > 0)
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
                if (nutrimentsServing.keys.length > 0)
                  Container(
                    height: nutrimentsServing.length * 30 + 5,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 74, 73, 73),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      itemCount: nutrimentsServing.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String strAmount = "";
                        String strKey = nutrimentsServing.keys.elementAt(index);
                        strAmount = nutrimentsServing[strKey].toString();
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  DataUtils.capitalizeFirstLetter(strKey),
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  strAmount,
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
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            // color: const Color.fromARGB(255, 110, 109, 109),
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        CommonBizLogic.addSugarIntake(
                            productDetailData["code"], qtyNumber);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OneClickConfirmPage(
                                    msg: "Sugar Intake added!")));
                        CommonBizLogic.getSugarIntakeToday();
                      } catch (e) {
                        Log.instance.e(e);
                        Toast.toast(context,
                            msg: "${e.toString()}",
                            position: ToastPostion.bottom);
                      }
                    },
                    child:
                        Text('Confirm', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
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
    );
  }

  @override
  void specificInit() {}
}
