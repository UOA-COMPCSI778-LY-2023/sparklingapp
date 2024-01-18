import 'package:flutter/material.dart';
import 'NavigatePage.dart';
import '../interface/PageStateTemplate.dart';

class IntakeAddConfirmPage extends StatefulWidget {
  @override
  _IntakeAddConfirmPageState createState() => _IntakeAddConfirmPageState();
}

class _IntakeAddConfirmPageState extends PageStateTemplate {
  @override
  void specificInit() {}

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
  @override
  Widget buildPageBody() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 74, 73, 73),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit to contents
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30,
              child: Icon(Icons.check, size: 40, color: Colors.white),
            ),
            SizedBox(height: 40),
            Text(
              'Sugar intake added!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NavigatePage()),
                      );
                    },
                    child: Text(
                      'Return to Home',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Color for 'Return to Home'
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Your code for "Continue Adding"
                    },
                    child: Text(
                      'Continue Adding',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey, // Color for 'Continue Adding'
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
