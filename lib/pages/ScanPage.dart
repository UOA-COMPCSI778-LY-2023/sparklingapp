import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:sugatiol/Configuration/Global.dart';

import '../Business/GetProductInfoFromOpenFood.dart';
import '../Configuration/APIList.dart';
import '../components/MyHttpRequest.dart';
import '../components/Router.dart';
import '../components/Toast.dart';
import '../components/barcode/detector_view.dart';
import '../components/barcode/barcode_detector_painter.dart';
import '../interface/PageStateTemplate.dart';
import 'ProductDetailPage.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends PageStateTemplate {
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

        // 使用 ConcreteHandlerA 发送请求
        GetProductInfoFromOpenFood getProductInfoFromOpenFood =
            GetProductInfoFromOpenFood();
        Response response = await MyHttpRequest.instance
            .sendRequest(url, {}, getProductInfoFromOpenFood);

        Map productData = response.data;
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

  @override
  AppBar buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      centerTitle: false,
      elevation: 0,
    );
  }

  @override
  Widget buildPageBody() {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;

    final size = MediaQuery.of(context).size;
    return Column(
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
                title: 'Pick up a picture',
                customPaint: _customPaint,
                text: _text,
                onImage: _processImage,
                initialDetectionMode: DebugCfg.isDebug
                    ? DetectorViewMode.gallery
                    : DetectorViewMode.liveFeed,
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
              String productName = "";
              String productBrand = "";
              String productImageUrl = "";
              if (productData["product_name"] != null) {
                productName = productData["product_name"];
              }
              if (productData["brands"] != null) {
                productBrand = productData["brands"];
              }
              if (productData["image_front_url"] != null) {
                productImageUrl = productData["image_front_url"];
              }
              return Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            (productName != "") ? Colors.green : Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: ((productName != "") && (productImageUrl != ""))
                        ? Image.network(productImageUrl)
                        : Icon(
                            Icons.breakfast_dining,
                            color: (productName != "")
                                ? Colors.white
                                : Colors.grey,
                          ),
                    title: Text(
                      '${(productBrand != "") ? productBrand + " - " : ""} ${(productName != "") ? productName : "Unknown product"}',
                      style: TextStyle(
                          color:
                              (productName != "") ? Colors.white : Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 12,
                    ),
                    onTap: () {
                      (productName != "")
                          ? Navigator.of(context).push<void>(
                              MyRouter.createRoute(
                                  ProductDetailPage(
                                      productDetailData: productData),
                                  "right"))
                          : Toast.toast(context,
                              msg: "This product detail is not available",
                              position: ToastPostion.bottom);
                      ;
                    },
                  ));
            },
          ),
        ),
      ],
    );
  }

  @override
  void specificInit() {
    // TODO: implement specificInit
  }
}
