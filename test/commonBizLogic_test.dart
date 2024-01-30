import 'package:flutter_test/flutter_test.dart';
import 'package:sugatiol/Configuration/Global.dart';
import 'package:sugatiol/components/CommonBizLogic.dart';

void main() {
  group('CommonBizLogic', () {
    test('CommonBizLogic.getSugarIntakeToday: Correctly get daily sugar intake',
        () async {
      double oldValue = TempData.todaySugarIntakeTotal.value;
      await CommonBizLogic.getSugarIntakeToday();
      expect(TempData.todaySugarIntakeTotal.value, isNot(oldValue));
    });

    test('CommonBizLogic.addSugarIntake: Correctly add daily sugar intake',
        () async {
      await CommonBizLogic.getSugarIntakeToday();
      double oldValue = TempData.todaySugarIntakeTotal.value;
      await CommonBizLogic.addSugarIntake("9417056003977", 1);
      double newValue = TempData.todaySugarIntakeTotal.value;
      expect(newValue, isNot(oldValue));
    });

    test(
        'CommonBizLogic.listSugarIntakesToday: Correctly get today intake list',
        () async {
      List todayList = await CommonBizLogic.listSugarIntakesToday();
      expect(todayList.length, greaterThan(1));
    });

    test(
        'CommonBizLogic.getIntakeListToday: Correctly set today intake into member',
        () async {
      List oldValue = TempData.intakeListToday.value;
      await CommonBizLogic.getIntakeListToday();
      expect(oldValue.length, isNot(TempData.intakeListToday.value.length));
    });
  });
}
