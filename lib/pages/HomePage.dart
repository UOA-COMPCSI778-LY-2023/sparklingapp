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
    double contentHeight =
        MediaQuery.of(context).size.height - 220 - 200; //窗口模式下需要减120，否则底部会留空
    if (contentHeight < 60) contentHeight = 60;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black, //标题行背景色
        centerTitle: false, //标题居中显示
        elevation: 0, //去掉底部阴影
        actions: [
          IconButton(
              onPressed: () async {
                // await Navigator.of(context).push<void>(MyRouter.createRoute(Cfg_VoterPage(), "top"));
              },
              icon: Icon(Icons.abc))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "1",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            children: [Text("2", style: TextStyle(color: Colors.white))],
          ),
          Column(
            children: [Text("3", style: TextStyle(color: Colors.white))],
          )
        ],
      ),
    );
  }
}
