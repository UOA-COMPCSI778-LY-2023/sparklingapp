import 'package:flutter/material.dart';
import 'package:sugatiol/Business/SetSugarTarget.dart';
import '../components/MyHttpRequest.dart';
import '../interface/PageStateTemplate.dart';
import '../components/LogUtils.dart';
import '../Configuration/APIList.dart';
import 'IntakeGoalConfirmPage.dart';
import 'package:dio/dio.dart';
import 'ErrorPage.dart';

class IntakeLimitEditPage extends StatefulWidget {
  @override
  IntakeLimitEditPage({Key? key}) : super(key: key);
  _IntakeLimitEditPageState createState() => _IntakeLimitEditPageState();
}

class _IntakeLimitEditPageState extends PageStateTemplate {
  final TextEditingController _controller = TextEditingController();

  @override
  void specificInit() {
    _controller.text =
        '100'; // Initialize the text field with the current sugar limit
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
    // Calculate the top padding as a percentage of the screen height
    double topPadding = MediaQuery.of(context).size.height * 0.075;
    double otherPadding = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding:
            EdgeInsets.fromLTRB(otherPadding, topPadding, otherPadding, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: topPadding),
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip
                  .none, // Allows the icon to be positioned out of the stack
              children: [
                Card(
                  color: Color.fromARGB(255, 74, 73, 73),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                            height:
                                32), // Space for the edit icon inside the card
                        Text(
                          'New Daily Sugar Intake Limit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: topPadding),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.orange,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height:
                                topPadding), // Reduce the space after the text field
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top:
                      -75, // Position the icon half outside the top of the card
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Blue background color
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8), // Padding for the circle
                      child: Icon(Icons.edit, color: Colors.white, size: 45),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: topPadding), // 保存按钮前的空间

            // 保存按钮
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: MediaQuery.of(context).size.width - 32,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  String username = "jnz121";
                  double sugarTarget = double.tryParse(_controller.text) ?? 0;
                  await setSugarLimit(username, sugarTarget);
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setSugarLimit(String user, double sugarTarget) async {
    Map<String, dynamic> parameters = {
      "username": user,
      "sugarTarget": sugarTarget //int.parse(_controller.text)
    };
    try {
      String api = APIList.lightSugarAPI["setSugarTarget"];
      SetSugarTarget setSugarTarget = SetSugarTarget(parameters);
      Response response = await MyHttpRequest.instance
          .sendRequest(api, parameters, setSugarTarget);
      // 检查响应状态和内容
      if (response.data["ack"] == "success") {
        // 成功响应，导航到确认页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IntakeGoalConfirmPage()),
        );
      } else if (response.data["ack"] == "failure") {
        // 失败响应，导航到错误页面
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ErrorPage(errorMessage: response.data["message"])),
        );
      }
    } catch (e) {
      Log.instance.e(e);
      // Show an error message
    }
  }
}
