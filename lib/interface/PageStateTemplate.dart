import 'package:flutter/material.dart';

abstract class PageStateTemplate extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    initializePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: buildPageBody(),
    );
  }

  void initializePage() {
    commonInit();
    specificInit();
  }

  void commonInit() {}

  void specificInit();

  Widget buildPageBody();

  AppBar? buildAppBar();
}
