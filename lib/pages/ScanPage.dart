import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sugatiol/Configuration/Global.dart';

import '../Business/GetProductInfoFromOpenFood.dart';
import '../Configuration/APIList.dart';
import '../components/Button.dart';
import '../components/LogUtils.dart';
import '../components/MyHttpRequest.dart';
import '../components/Router.dart';
import '../components/Toast.dart';
import '../components/barcode/detector_view.dart';
import '../components/barcode/barcode_detector_painter.dart';
import '../interface/PageStateTemplate.dart';
import 'ProductDetailPage.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

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
  Map notExistProducts = {};
  bool isAIBusy = false;
  static ValueNotifier<String> aiAnswer = ValueNotifier("");
  bool _showScanBarcode = true;

  Future<void> addProduct(String barcode) async {
    try {
      if (products[barcode] == null) {
        String api = APIList.lightSugarAPI["getFoodByBarcode"];
        // barcode = "9300675090414";
        String url = api.replaceAll('{0}', barcode);
        GetProductInfoFromOpenFood getProductInfoFromOpenFood =
            GetProductInfoFromOpenFood();
        Response response = await MyHttpRequest.instance
            .sendRequest(url, {}, getProductInfoFromOpenFood);

        if (response.data["ack"] == "success") {
          Map productData = response.data["data"];
          products =
              {}; //always clear all the product data, only show one product
          if (products[barcode] == null) {
            products[barcode] = productData;
            setState(() {});
          }
        } else if (response.data["ack"] == "failure") {
          Toast.toast(context,
              msg:
                  "Product not found in database, try to search from openfoodstuff",
              position: ToastPostion.bottom);
          String api = APIList.openFoodAPI["getFoodByBarcode"];
          String url = api.replaceAll('{0}', barcode);
          GetProductInfoFromOpenFood getProductInfoFromOpenFood =
              GetProductInfoFromOpenFood();
          Response response = await MyHttpRequest.instance
              .sendRequest(url, {}, getProductInfoFromOpenFood)
              .onError((error, stackTrace) {
            Log.instance.e(error);
            return Future.error(error ?? "Unknown error");
          });
          if (response.data is Map && response.data["status"] == "success") {
            Map productData = response.data["product"];
            products =
                {}; //always clear all the product data, only show one product
            if (products[barcode] == null) {
              products[barcode] = productData;
              setState(() {});
            }
          } else {
            notExistProducts[barcode] = response;
          }
        }
      }
    } catch (e) {
      Toast.toast(context,
          msg: "${e.toString()}", position: ToastPostion.bottom);
      notExistProducts[barcode] = e;
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  Future<void> resizeImage(String inputFilePath) async {
    // 从文件中以Uint8List的形式读取图片
    Uint8List imageBytes = await File(inputFilePath).readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null && image.width > 500) {
      //最大宽度500
      int newWidth = image.width > 500 ? 500 : image.width;
      int newHeight = (image.height * newWidth / image.width).toInt();

      // 调整图片尺寸，例如将宽度和高度减半
      img.Image resized =
          img.copyResize(image, width: newWidth, height: newHeight);

      // 将调整后的图片保存回文件
      // 这里可以选择保存为不同格式，如jpeg、png等
      await File(inputFilePath)
          .writeAsBytes(img.encodeJpg(resized, quality: 85));
    }
  }

  Future<String> saveImageToFile(img.Image? image) async {
    // Uint8List imageData = inputImage.bytes!;
    // img.Image? image = img.decodeImage(imageData);
    String fileName = Uuid().v4() + ".jpg";
    String path = "./" + fileName;
    if (image != null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = '${documentsDirectory.path}/' + fileName;
      File file = File(path);
      file.writeAsBytesSync(img.encodePng(image));
    } else {
      throw Exception('Did not get image');
    }
    return path;
  }

  img.Image? convertNV21ToImage(Uint8List yuvBytes, int width, int height) {
    final img.Image rgbImage = img.Image(width, height); // 创建RGB图像

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * width + x;
        final int uvIndex = width * height + (y ~/ 2) * width + (x & ~1);

        final int Y = yuvBytes[yIndex];
        final int U = yuvBytes[uvIndex];
        final int V = yuvBytes[uvIndex + 1];

        rgbImage.data[yIndex] = yuvToRgb(Y, U, V);
      }
    }
    return rgbImage;
  }

  int yuvToRgb(int y, int u, int v) {
    var r = (y + v * 1436 / 1024 - 179).round().clamp(0, 255);
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91)
        .round()
        .clamp(0, 255);
    var b = (y + u * 1814 / 1024 - 227).round().clamp(0, 255);
    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }

  void getResponseFromAI(InputImage inputImage) async {
    try {
      isAIBusy = true;

      Uint8List imageBytes;
      if (inputImage.bytes != null) {
        img.Image? newimageBytes = convertNV21ToImage(
            inputImage.bytes!,
            inputImage.metadata!.size.width.toInt(),
            inputImage.metadata!.size.height.toInt());
        String filePath = await saveImageToFile(newimageBytes);
        imageBytes = await File(filePath).readAsBytes();
        // imageBytes = Uint8List.fromList(inputImage.bytes!);
        //尝试将图像存为文件，然后再读取
      } else {
        await resizeImage(inputImage.filePath!);
        imageBytes = await File(inputImage.filePath!).readAsBytes();
      }

      final gemini = Gemini.instance;
      await gemini.textAndImage(
          text: APIList.geminiPrompt["identifyFood"],
          images: [imageBytes]).then((value) {
        aiAnswer.value = (value?.content?.parts?.last.text ?? '');
        isAIBusy = false;
        setState(() {});
      }).catchError((e) {
        isAIBusy = false;
        if (e is DioError) {
          Log.instance.e(
              "DioError received: ${e.response?.statusCode} - ${e.response?.statusMessage}");
          Log.instance.e("Error data: ${e.response?.data}");
        } else {
          Log.instance.e("Error while getting response from AI: $e");
        }
      }).whenComplete(() => isAIBusy = false);
      isAIBusy = false;
    } catch (e) {
      if (e is DioError) {
        switch (e.response?.statusCode) {
          case 400:
            {
              Log.instance.d("400 Server error");
            }
          case 404:
            {
              Log.instance.d("404 Not Found");
            }
          default:
            {
              Log.instance.d(e.response?.data);
              Log.instance.d(e.response?.headers);
              Log.instance.d(e.response?.requestOptions);
            }
        }
      } else {
        Log.instance.d(e);
      }
      isAIBusy = false;
    } finally {
      isAIBusy = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    setState(() {
      _text = '';
    });

    if (_showScanBarcode) {
      barcodes = await _barcodeScanner.processImage(inputImage);
      barcodes.forEach((bcode) {
        if (bcode.rawValue != null &&
            !products.keys.toList().contains(bcode.rawValue) &&
            !notExistProducts.keys.toList().contains(bcode.rawValue)) {
          String bcodeText = bcode.rawValue!;
          addProduct(bcodeText);
        }
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
        _customPaint = null;
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }

    if (!isAIBusy && !_showScanBarcode) {
      getResponseFromAI(inputImage);
    }
  }

  @override
  AppBar buildAppBar() {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Scan Barcode",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            "Record the Food You are Eating",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      leading: barBackButton(),
    );
  }

  @override
  Widget buildPageBody() {
    double contentHeight = MediaQuery.of(context).size.height - 220 - 200;
    if (contentHeight < 60) contentHeight = 60;
    final size = MediaQuery.of(context).size;
    String productName = "";
    String productBrand = "";
    String productImageUrl = "";
    Map productData = {};
    if (products.keys.toList().length > 0) {
      productData = products[products.keys.toList()[0]];
      if (productData["product_name"] != null) {
        productName = productData["product_name"];
      }
      if (productData["brands"] != null) {
        productBrand = productData["brands"];
      }
      if (productData["img_url"] != null) {
        productImageUrl = productData["img_url"];
      }
      if (productData["image_front_url"] != null) {
        productImageUrl = productData["image_front_url"];
      }
    }
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: 300,
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
        _buildTabBar(),
        SizedBox(
          height: 15,
        ),
        if (products.keys.toList().length > 0 && _showScanBarcode)
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: (productName != "") ? Colors.green : Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ((productName != "") && (productImageUrl != ""))
                  ? Image.network(productImageUrl)
                  : Icon(
                      Icons.breakfast_dining,
                      color: (productName != "") ? Colors.white : Colors.grey,
                    ),
              title: Text(
                '${(productBrand != "") ? productBrand + " - " : ""} ${(productName != "") ? productName : "Unknown product"}',
                style: TextStyle(
                    color: (productName != "") ? Colors.white : Colors.grey),
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
                    ? Navigator.of(context).push<void>(MyRouter.createRoute(
                        ProductDetailPage(productDetailData: productData),
                        "right"))
                    : Toast.toast(context,
                        msg: "This product detail is not available",
                        position: ToastPostion.bottom);
              },
            ),
          ),
        SizedBox(
          height: 15,
        ),
        if (!_showScanBarcode)
          ValueListenableBuilder<String>(
              valueListenable: aiAnswer,
              builder: (c, ac, _) {
                return ac.isNotEmpty
                    ? Expanded(
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "Google Gemini AI Tips: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                ListTile(
                                  title: Text(
                                    ac,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Text("");
              }),
      ],
    );
  }

  @override
  void specificInit() {
    Gemini.init(apiKey: 'AIzaSyDuln2ikwt50BUdzKhQ5iahntcdXcwBzCw');
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _showScanBarcode = true;
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          _showScanBarcode ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Scanning',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _showScanBarcode = false;
                });
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          !_showScanBarcode ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Food Detection',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
