import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
      if (contentHeight < 60) contentHeight = 60;

      final size = MediaQuery.of(context).size;

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Scan Result",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                        height: 200,
                        width: size.width - 20,
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.ac_unit)),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 74, 73, 73),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_alarm,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Coca Cola equals to 32 sugar cubes",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Product Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 74, 73, 73),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1, // 占用可用空间的1份
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // color: Colors.red,
                              // height: 100,
                              child: Center(
                                  child: Image(
                                image: AssetImage('assets/cococola.png'),
                              )),
                            ),
                          ),
                          Expanded(
                            flex: 2, // 占用可用空间的2份
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Coca Cola',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nutrition Table",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Per Serving",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 6 * 30,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 74, 73, 73),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Expanded(
                        flex: 1,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              height: 25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Calories",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "0 g",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                // color: const Color.fromARGB(255, 110, 109, 109),
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Handle add action
                      },
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle cancel action
                      },
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } catch (e) {
      return Scaffold(body: Text(e.toString()));
    }
  }
}
