import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/LogUtils.dart';

void main() {
  group('Log', () {
    test('Log.getLogStr: Correctly convert error information to string', () {
      var data = "error information";
      var expectedFormat = 'error information';
      var formattedDate = Log.getLogStr(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.addErrLog: Correctly adding error log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.addErrLog(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.addInfoLog: Correctly adding information log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.addInfoLog(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.i: Correctly showing information log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.i(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.w: Correctly showing information log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.w(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.e: Correctly showing information log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.e(data);
      expect(formattedDate, expectedFormat);
    });

    test('Log.wtf: Correctly showing information log', () {
      var data = "error information";
      var expectedFormat = null;
      var formattedDate = Log.instance.wtf(data);
      expect(formattedDate, expectedFormat);
    });
  });
}
