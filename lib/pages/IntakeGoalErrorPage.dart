import 'package:flutter/material.dart';
import 'NavigatePage.dart';
import '../interface/PageStateTemplate.dart';

class IntakeGoalErrorPage extends StatefulWidget {
  final String errorMessage;

  const IntakeGoalErrorPage({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  _IntakeGoalErrorPage createState() => _IntakeGoalErrorPage(eMessage:errorMessage);
}

class _IntakeGoalErrorPage extends PageStateTemplate {
  final String eMessage;

  _IntakeGoalErrorPage({required this.eMessage});

  @override
  void specificInit() {
    // 在这里初始化任何需要的数据
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
    );
  }

  @override
  Widget buildPageBody() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 屏幕宽度的 80%
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 74, 73, 73),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 内容适配
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(Icons.close, size: 40, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              this.eMessage, // 显示传入的错误信息
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigatePage()),
                );
              },
              child:
                  Text('Back to home', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Try again', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
