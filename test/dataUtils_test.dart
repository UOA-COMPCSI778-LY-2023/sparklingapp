import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/components/DataUtils.dart';

void main() {
  group('DataUtils', () {
    test('DataUtils.getIpFromUrl: Correctly get ip from url', () {
      var data = "https://world.openfoodfacts.org/api/v3/product";
      var expectedFormat = 'world.openfoodfacts.org';
      var formattedDate = DataUtils.getIpFromUrl(data);
      expect(formattedDate, expectedFormat);
    });

    test('DataUtils.getDayFromDateString: Correctly get day string from date',
        () {
      var date = "2024-01-30 00:00:00";
      var expectedFormat = 'Tue';
      var formattedDate = DataUtils.getDayFromDateString(date);
      expect(formattedDate, expectedFormat);
    });

    test('DataUtils.capitalizeFirstLetter: Correctly capitalize first letter',
        () {
      var data = "hi";
      var expectedFormat = 'Hi';
      var formattedDate = DataUtils.capitalizeFirstLetter(data);
      expect(formattedDate, expectedFormat);
    });
  });
}
