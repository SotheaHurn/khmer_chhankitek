import 'package:khmer_chhankitek/khmer_chhankitek.dart';

void main() {
  Chhankitek.now().toString();
  Chhankitek.get(DateTime(2024, 5, 12)).toString();
  Chhankitek.get(DateTime(2025, 2, 12)).toString();

  Chhankitek.now().dayOfWeek;
  Chhankitek.now().lunarDay;
  Chhankitek.now().lunarMonth;
  Chhankitek.now().lunarZodiac;
  Chhankitek.now().lunarEra;
  Chhankitek.now().lunarYear;
  Chhankitek.now().solarDay;
  Chhankitek.now().solarMonth;
  Chhankitek.now().solarYear;
}
