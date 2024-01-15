import 'package:flutter/material.dart';
import '../components/Button.dart';
import '../components/Router.dart';
import 'HomePage.dart';
import 'ScanPage.dart';
import 'object_detector_view.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int _currentIndex = 0;
  final List<Widget> _pageList = [
    HomePage(),
    HomePage(),
    Text(" "),
    HomePage(),
    HomePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        shape: CircleBorder(side: BorderSide(color: Colors.grey)),
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context)
              .push<void>(MyRouter.createRoute(ScanPage(), "bottom"));
        },
      ),
      floatingActionButtonAnimator: scalingAnimation(),
      floatingActionButtonLocation: CustomFloatingActionButtonFactory(
              FloatingActionButtonLocation.centerDocked, 0, 30)
          .createLocation(),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pageList,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        //iconSize: 18.0,
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: ("Today")),
          BottomNavigationBarItem(icon: Icon(Icons.plus_one), label: (" ")),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: ("History")),
          BottomNavigationBarItem(
              icon: Icon(Icons.description), label: ("Report")),
        ],
      ),
    );
  }
}
