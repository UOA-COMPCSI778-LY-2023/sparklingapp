import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../Configuration/APIList.dart';
import '../components/MyHttpRequest.dart';
import '../components/Toast.dart';
import '../components/barcode/detector_view.dart';
import '../components/barcode/barcode_detector_painter.dart';

class ScanPage extends StatefulWidget {
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  List<Barcode> barcodes = [];
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  Map products = {}; //products[barcode] = productData

  Future<void> addProduct(String barcode) async {
    try {
      if (products[barcode] == null) {
        String api = APIList.openFoodAPI["getFoodByBarcode"];
        String url = api.replaceAll('{0}', barcode);
        DateTime beginTime = DateTime.now();
        Map productData = await MyHttpRequest.sendFutureGetRequest(url);
        DateTime endTime = DateTime.now();
        if (products[barcode] == null) {
          products[barcode] = productData;
          setState(() {});
        }
      }
    } catch (e) {
      Toast.toast(context,
          msg: "${e.toString()}", position: ToastPostion.bottom);
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
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
                    width: size.width - 20,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: DetectorView(
                      title: 'Barcode Scanner',
                      customPaint: _customPaint,
                      text: _text,
                      onImage: _processImage,
                      initialCameraLensDirection: _cameraLensDirection,
                      onCameraLensDirectionChanged: (value) =>
                          _cameraLensDirection = value,
                    ),
                  ),
                  // Text(barcode),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Scan History: ${products.keys.length}",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: products.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map productData =
                        products[products.keys.toList()[index]]["product"];
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
                          title: Text(
                              '${productData["brands"] != null ? productData["brands"] + " - " : ""} - ${productData["product_name"]}',
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
      // return DetectorView(
      //   title: 'Barcode Scanner',
      //   customPaint: _customPaint,
      //   text: _text,
      //   onImage: _processImage,
      //   initialCameraLensDirection: _cameraLensDirection,
      //   onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      // );
    } catch (e) {
      return Scaffold(body: Text(e.toString()));
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    barcodes = await _barcodeScanner.processImage(inputImage);
    barcodes.forEach((bcode) {
      String bcodeText = bcode.rawValue!;
      addProduct(bcodeText);
    });

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = BarcodeDetectorPainter(
        barcodes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Barcodes found: ${barcodes.length}\n\n';
      for (final barcode in barcodes) {
        text += 'Barcode: ${barcode.rawValue}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
