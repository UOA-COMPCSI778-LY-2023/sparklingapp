import 'package:flutter/material.dart';
import 'NavigatePage.dart';
import '../interface/PageStateTemplate.dart';

class OneClickConfirmPage extends StatefulWidget {
  @override
  _OneClickConfirmPageState createState() => _OneClickConfirmPageState();
}

class _OneClickConfirmPageState extends PageStateTemplate {
  @override
  void specificInit() {
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
            SizedBox(height: 20),
            Text(
              'Sugar Intake added!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigatePage()),
                );
              },
              child: Text('OK', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white)),
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