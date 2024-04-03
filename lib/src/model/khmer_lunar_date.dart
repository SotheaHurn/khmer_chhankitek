import 'package:khmer_chhankitek/khmer_chhankitek.dart';

class KhmerLunarDate {
  /// អាទិត្យ , ច័ន្ទ , អង្គារ ...
  final String dayOfWeek;

  /// ថ្ងៃតាមច័ន្ទគតិ
  final LunarDay lunarDay;

  /// ខែតាមច័ន្ទគតិ : មិគសិរ , បុស្ស , មាឃ ...
  final String lunarMonth;

  /// រាសីចក្រតាមច័ន្ទគតិ : ជូត , ឆ្លូវ , ខាល ...
  final String lunarZodiac;

  /// សម័យតាមច័ន្ទគតិ : សំរឹទ្ធិស័ក , ឯកស័ក , ទោស័ក ...
  final String lunarEra;

  /// ឆ្នាំតាមច័ន្ទគតិ
  final String lunarYear;

  /// ឆ្នាំសកល
  final String solarYear;

  /// ខែសកល
  final String solarMonth;

  /// ថ្ងៃសកល
  final String solarDay;

  KhmerLunarDate({
    required this.dayOfWeek,
    required this.lunarDay,
    required this.lunarMonth,
    required this.lunarZodiac,
    required this.lunarEra,
    required this.lunarYear,
    required this.solarYear,
    required this.solarMonth,
    required this.solarDay,
  });

  @override
  String toString() {
    return 'ថ្ងៃ$dayOfWeek ${lunarDay.moonCountKh}${lunarDay.moonStatusKh} ខែ$lunarMonth ឆ្នាំ$lunarZodiac $lunarEra ពុទ្ធសករាជ $lunarYear\nត្រូវនឹងថ្ងៃទី$solarDay ខែ$solarMonth ឆ្នាំ$solarYear';
  }
}
