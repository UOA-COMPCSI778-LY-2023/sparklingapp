import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/DateUtils.dart';

void main() {
  group('DataUtils', () {
    test('MyDateUtils.formatToddMMyyy: Correctly formats ddMMyyyy date', () {
      var date = DateTime(2024, 1, 30);
      var expectedFormat = '30/01/2024';
      var formattedDate = MyDateUtils.formatToddMMyyy(date);
      expect(formattedDate, expectedFormat);
    });

    test(
        'MyDateUtils.formatToString: Correctly formats yyyy-MM-dd HH:mm:ss date',
        () {
      var date = DateTime(2024, 1, 30, 0, 0, 0);
      var expectedFormat = '2024-01-30 00:00:00';
      var formattedDate = MyDateUtils.formatToString(date);
      expect(formattedDate, expectedFormat);
    });

    test('MyDateUtils.formatToHHmmss: Correctly formats HH:mm:ss date', () {
      var date = DateTime(2024, 1, 30, 0, 0, 0);
      var expectedFormat = '00:00:00';
      var formattedDate = MyDateUtils.formatToHHmmss(date);
      expect(formattedDate, expectedFormat);
    });

    test('MyDateUtils.formatToyyyMMdd: Correctly formats yyyy-MM-dd date', () {
      var date = DateTime(2024, 1, 30, 0, 0, 0);
      var expectedFormat = '2024-01-30';
      var formattedDate = MyDateUtils.formatToyyyMMdd(date);
      expect(formattedDate, expectedFormat);
    });

    test('MyDateUtils.yyyMMddToDate: Correctly formats date', () {
      var date = "2024-01-30 00:00:00";
      var expectedFormat = DateTime(2024, 1, 30, 0, 0, 0);
      var formattedDate = MyDateUtils.yyyMMddToDate(date);
      expect(formattedDate, expectedFormat);
    });

    test('MyDateUtils.format: Correctly formats yesterday date', () {
      var date = DateTime.now().add(Duration(days: -1));
      var expectedFormat = 'yesterday';
      var formattedDate = MyDateUtils.format(date);
      expect(formattedDate, expectedFormat);
    });
  });
}
