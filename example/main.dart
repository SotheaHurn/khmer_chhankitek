import 'package:khmer_chhankitek/khmer_chhankitek.dart';

void main() {
  // Current date
  Chhankitek.now();

  // Specific date
  Chhankitek.get(DateTime(2024, 5, 12));

  // use to string to khmer fomat
  Chhankitek.get(DateTime(2025, 2, 12)).toString();

  // other method
  KhmerLunarDate khmerLunarDate = Chhankitek.now();

  /// អាទិត្យ , ច័ន្ទ , អង្គារ ...
  khmerLunarDate.dayOfWeek;

  /// ថ្ងៃតាមច័ន្ទគតិ
  khmerLunarDate.lunarDay;

  /// ថ្ងៃជាលេខខ្មែរ
  khmerLunarDate.lunarDay.moonCountKh;

  /// កើត , រោច
  khmerLunarDate.lunarDay.moonStatusKh;

  /// ខែតាមច័ន្ទគតិ : មិគសិរ , បុស្ស , មាឃ ...
  khmerLunarDate.lunarMonth;

  /// រាសីចក្រតាមច័ន្ទគតិ : ជូត , ឆ្លូវ , ខាល ...
  khmerLunarDate.lunarZodiac;

  /// សម័យតាមច័ន្ទគតិ : សំរឹទ្ធិស័ក , ឯកស័ក , ទោស័ក ...
  khmerLunarDate.lunarEra;

  /// ឆ្នាំតាមច័ន្ទគតិ
  khmerLunarDate.lunarYear;

  /// ថ្ងៃសកល
  khmerLunarDate.solarDay;

  /// ខែសកល
  khmerLunarDate.solarMonth;

  /// ឆ្នាំសកល
  khmerLunarDate.solarYear;
}
