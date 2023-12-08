import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../components/Toast.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    // 释放摄像头控制器资源
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.length > 0) {
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller!.initialize();
      print("Finish camera initialization");

      //await _controller!.initialize();
      setState(() {});
    } else {
      Toast.toast(context,
          msg: "No available camera", position: ToastPostion.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      print(snapshot.toString());
                      print("Check connection status");
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Camera error: ${snapshot.error}');
                        }
                        // 如果摄像头初始化完成，则显示摄像头预览
                        return CameraPreview(_controller!);
                      } else {
                        // 否则显示一个加载指示器
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Scan History: 4",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.breakfast_dining,
                          color: Colors.white,
                        ),
                        title: Text('Product ${index + 1}',
                            style: TextStyle(color: Colors.white)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 12,
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ScanPage()), //
                          // );
                        },
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
