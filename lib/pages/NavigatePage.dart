import 'package:flutter/material.dart';
import '../components/Button.dart';
import '../components/Router.dart';
import 'HomePage.dart';
import 'ScanPage.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int _currentIndex = 0;
  final List<Widget> _pageList = [
    HomePage(),
    Text(" "),
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
        backgroundColor: Colors.blue,
        shape: CircleBorder(side: BorderSide(color: Colors.black)),
        elevation: 0,
        child: Icon(Icons.document_scanner, color: Colors.white),
        onPressed: () {
          Navigator.of(context)
              .push<void>(MyRouter.createRoute(ScanPage(), "bottom"));
        },
      ),
      floatingActionButtonAnimator: scalingAnimation(),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, 30),
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
        unselectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: (" ")),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: (" ")),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: (" ")),
        ],
      ),
    );
  }
}
