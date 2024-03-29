import 'package:flutter/material.dart';
import 'NavigatePage.dart';
import '../interface/PageStateTemplate.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;

  const ErrorPage({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  _ErrorPage createState() => _ErrorPage(eMessage:errorMessage);
}

class _ErrorPage extends PageStateTemplate {
  final String eMessage;

  _ErrorPage({required this.eMessage});

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
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 74, 73, 73),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(Icons.close, size: 40, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              this.eMessage, 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('Back to home', style: TextStyle(
                    fontSize: 24,
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
