import 'package:khmer_chhankitek/khmer_chhankitek.dart';

class Chhankitek {
  static late DateTime _newYearDateTime;

  /// Current Date
  static KhmerLunarDate now() {
    return _toKhmerLunarDateFormat(DateTime.now());
  }

  /// Specific Date
  static KhmerLunarDate get(DateTime dateTime) {
    return _toKhmerLunarDateFormat(dateTime);
  }

  static KhmerLunarDate _toKhmerLunarDateFormat(DateTime target) {
    LunarDate lunarDate = _findLunarDate(target);
    LunarDay khmerLunarDay = _getKhmerLunarDay(lunarDate.day);
    int beYear = _getBeYear(target);
    int lunarZodiac = _getAnimalYear(target);
    int lunarEra = _getJolakSakarajYear(target) % 10;
    return KhmerLunarDate(
      dayOfWeek: ChhankitekUtils.getDayOfWeekInKhmer(target),
      lunarDay: khmerLunarDay,
      lunarMonth: Constant.lunarMonthsFormat[lunarDate.month]!,
      lunarZodiac: Constant.animalYear[lunarZodiac]!,
      lunarEra: Constant.eraYear[lunarEra]!,
      lunarYear: ChhankitekUtils.convertIntegerToKhmerNumber(beYear),
      solarYear: ChhankitekUtils.convertIntegerToKhmerNumber(target.year),
      solarMonth: Constant.solarMonthsKh[target.month - 1]!,
      solarDay: ChhankitekUtils.convertIntegerToKhmerNumber(target.day),
    );
  }

  static LunarDay _getKhmerLunarDay(int day) {
    int count = (day % 15) + 1;
    int moonStatus =
        day > 14 ? Constant.moonStatus['រោច']! : Constant.moonStatus['កើត']!;
    return LunarDay(
        moonCount: count,
        moonStatus: moonStatus,
        moonCountKh: ChhankitekUtils.convertIntegerToKhmerNumber(count),
        moonStatusKh: Constant.moonStatusKH[moonStatus]!);
  }

  static int _getBeYear(DateTime date) {
    int tmp = date.year;
    if (_getVisakhaBochea(tmp).isBefore(date)) {
      return tmp + 544;
    }
    return tmp + 543;
  }

  static int _getAnimalYear(DateTime date) {
    int gregorianYear = date.year;
    _newYearDateTime = _getKhmerNewYearDateTime(gregorianYear);
    if (date.isBefore(_newYearDateTime)) {
      return (gregorianYear + 543 + 4) % 12;
    }
    return (gregorianYear + 544 + 4) % 12;
  }

  static int _getJolakSakarajYear(DateTime date) {
    int gregorianYear = date.year;
    if (date.isBefore(_newYearDateTime)) {
      return gregorianYear + 543 - 1182;
    }
    return gregorianYear + 544 - 1182;
  }

  static DateTime _getKhmerNewYearDateTime(int gregorianYear) {
    // ពីគ្រិស្ដសករាជ ទៅ ចុល្លសករាជ
    int jsYear = (gregorianYear + 544) - 1182;
    KhmerNewYearCal info = KhmerNewYearCal(jsYear: jsYear);
    int numberNewYearDay = 0;
    // ថ្ងៃ ខែ ឆ្នាំ ម៉ោង និង នាទី ចូលឆ្នាំ
    if (info.khmerNewYear.newYearsDaySotins[0].angsar == 0) {
      // ចូលឆ្នាំ ៤ ថ្ងៃ
      numberNewYearDay = 4;
    } else {
      // ចូលឆ្នាំ ៣ ថ្ងៃ
      numberNewYearDay = 3;
    }
    DateTime epochLerngSak = DateTime(
      gregorianYear,
      4,
      17,
      info.khmerNewYear.timeOfNewYear.hour,
      info.khmerNewYear.timeOfNewYear.minute,
    );
    LunarDate lunarDate = _findLunarDate(epochLerngSak);
    int diffFromEpoch = (((lunarDate.month - 4) * 30) + lunarDate.day) -
        (((info.khmerNewYear.lunarDateLerngSak.month - 4) * 30) +
            info.khmerNewYear.lunarDateLerngSak.day);
    return epochLerngSak
        .subtract(Duration(days: diffFromEpoch + numberNewYearDay - 1));
  }

  // Calculate date from DateTime to Khmer date
  static LunarDate _findLunarDate(DateTime target) {
    // Epoch Date: January 1, 1900
    DateTime epochDateTime = DateTime(1900, 1, 1, 0, 0, 0, 0);
    int khmerMonth = Constant.lunarMonths['បុស្ស']!;
    int khmerDay = 0; // 0 - 29 ១កើត ... ១៥កើត ១រោច ...១៤រោច (១៥រោច)

    // Move epoch month
    while (target.difference(epochDateTime).inDays >
        _getNumberOfDayInKhmerMonth(
            beMonth: khmerMonth, beYear: _getMaybeBEYear(epochDateTime))) {
      epochDateTime = epochDateTime.add(Duration(
          days: _getNumberOfDayInKhmerMonth(
              beMonth: khmerMonth, beYear: _getMaybeBEYear(epochDateTime))));

      khmerMonth = _nextMonthOf(
          khmerMonth: khmerMonth, beYear: _getMaybeBEYear(epochDateTime));
    }
    khmerDay += target.difference(epochDateTime).inDays;

    /**
     * Fix result display 15 រោច ខែ ជេស្ឋ នៅថ្ងៃ ១ កើតខែបឋមាសាធ
     * ករណី ខែជេស្ឋមានតែ ២៩ ថ្ងៃ តែលទ្ធផលបង្ហាញ ១៥រោច ខែជេស្ឋ
     */
    int totalDaysOfTheMonth = _getNumberOfDayInKhmerMonth(
        beMonth: khmerMonth, beYear: _getMaybeBEYear(target));
    if (totalDaysOfTheMonth <= khmerDay) {
      khmerDay = khmerDay % totalDaysOfTheMonth;
      khmerMonth = _nextMonthOf(
          khmerMonth: khmerMonth, beYear: _getMaybeBEYear(epochDateTime));
    }
    epochDateTime = epochDateTime
        .add(Duration(days: target.difference(epochDateTime).inDays));

    return LunarDate(
        day: khmerDay, month: khmerMonth, epochMoved: epochDateTime);
  }

  // Maximum number of day in Khmer Month
  static int _getNumberOfDayInKhmerMonth(
      {required int beMonth, required int beYear}) {
    if (beMonth == Constant.lunarMonths['ជេស្ឋ'] && _isKhmerLeapDay(beYear)) {
      return 30;
    }
    if (beMonth == Constant.lunarMonths['បឋមាសាឍ'] ||
        beMonth == Constant.lunarMonths['ទុតិយាសាឍ']) {
      return 30;
    }
    // មិគសិរ : 29 , បុស្ស : 30 , មាឃ : 29 .. 30 .. 29 ..30 .....
    return beMonth % 2 == 0 ? 29 : 30;
  }

  // A year with an extra day is called Chhantrea Thimeas (ចន្ទ្រាធិមាស) or Adhikavereak (អធិកវារៈ). This year has 355 days.
  static bool _isKhmerLeapDay(int beYear) {
    return _getProtetinLeap(beYear) == 2;
  }

  ///bodithey leap can be both leap-day and leap-month but following the khmer calendar rule, they can't be together on the same year, so leap day must be delayed to next year
  static int _getProtetinLeap(int beYear) {
    // return 0:regular, 1:leap month, 2:leap day (no leap month and day together)
    int b = _getBoditheyLeap(beYear);
    if (b == 3) {
      return 1;
    }
    if (b == 2 || b == 1) {
      return b;
    }
    // case of previous year is 3
    if (_getBoditheyLeap(beYear - 1) == 3) {
      return 2;
    }
    // normal case
    return 0;
  }

  // * Regular if year has 30 day
  // * leap month if year has 13 months
  // * leap day if Jesth month of the year has 1 extra day
  // * leap day and month: both of them
  /// @param adYear
  /// @returns {int} return 0:regular, 1:leap month, 2:leap day, 3:leap day and month
  static int _getBoditheyLeap(int adYear) {
    int result = 0;

    int avoman = _getAvoman(adYear);
    int bodithey = _getBodithey(adYear);

    // check bodithey leap month
    int boditheyLeap = 0;
    if (bodithey >= 25 || bodithey <= 5) {
      boditheyLeap = 1;
    }

    // check for avoman leap-day based on gregorian leap
    int avomanLeap = 0;
    if (_isKhmerSolarLeap(adYear) == 1) {
      if (avoman <= 126) {
        avomanLeap = 1;
      }
    } else {
      if (avoman <= 137) {
        // check for avoman case 137/0, 137 must be normal year (p.26)
        if (_getAvoman(adYear + 1) == 0) {
          avomanLeap = 0;
        } else {
          avomanLeap = 1;
        }
      }
    }

    // case of 25/5 consecutively
    // only bodithey 5 can be leap-month, so set bodithey 25 to none
    if (bodithey == 25) {
      int nextBodithey = _getBodithey(adYear + 1);
      if (nextBodithey == 5) {
        boditheyLeap = 0;
      }
    }

    // case of 24/6 consecutively, 24 must be leap-month
    if (bodithey == 24) {
      int nextBodithey = _getBodithey(adYear + 1);
      if (nextBodithey == 6) {
        boditheyLeap = 1;
      }
    }

    // format leap result (0:regular, 1:month, 2:day, 3:both)
    if (boditheyLeap == 1 && avomanLeap == 1) {
      result = 3;
    } else if (boditheyLeap == 1) {
      result = 1;
    } else if (avomanLeap == 1) {
      result = 2;
    }

    return result;
  }

  // Avoman: អាវមាន
  // Avoman determines if a given year is a leap-day year. Given a year in Buddhist Era as denoted as adYear
  // @param beYear (0 - 691)
  static int _getAvoman(int beYear) {
    int ahk = _getAharkun(beYear);
    return ((11 * ahk) + 25) % 692;
  }

  /// Aharkun: អាហារគុណ ឬ ហារគុណ
  /// Aharkun is used for Avoman and Bodithey calculation below. Given adYear as a target year in Buddhist Era
  /// @param beYear
  /// @returns {int}
  static int _getAharkun(int beYear) {
    int t = (beYear * 292207) + 499;
    // 800 days
    return (t / 800).floor() + 4;
  }

  // Bodithey: បូតិថី
  // Bodithey determines if a given beYear is a leap-month year. Given year target year in Buddhist Era
  // @return int (0-29)
  static int _getBodithey(int beYear) {
    int ahk = _getAharkun(beYear);
    // 11 days , 25 days , 692 days
    int avml = ((11 * ahk + 25) / 692).floor();
    int m = (avml + ahk + 29);
    return (m % 30);
  }

  // isKhmerSolarLeap
  // @param beYear
  // @returns {int}
  static int _isKhmerSolarLeap(int beYear) {
    int krom = _kromthupul(beYear);
    if (krom <= 207) {
      return 1;
    } else {
      return 0;
    }
  }

  // Kromathupul
  // @param beYear
  // @returns int (1-800)
  static int _kromthupul(int beYear) {
    int ah = _getAharkunMod(beYear);
    return 800 - ah;
  }

  /// getAkhakunMod
  /// @param beYear
  /// @returns {int}
  static int _getAharkunMod(int beYear) {
    int t = (beYear * 292207) + 499;
    return t % 800;
  }

  static int _getMaybeBEYear(DateTime date) {
    int d = date.month;
    if (d <= (Constant.solarMonths['APR']! + 1)) {
      return date.year + 543;
    }
    return date.year + 544;
  }

  static int _nextMonthOf({required int khmerMonth, required int beYear}) {
    if (khmerMonth == Constant.lunarMonths['មិគសិរ']) {
      return Constant.lunarMonths['បុស្ស']!;
    }
    if (khmerMonth == Constant.lunarMonths['បុស្ស']) {
      return Constant.lunarMonths['មាឃ']!;
    }
    if (khmerMonth == Constant.lunarMonths['មាឃ']) {
      return Constant.lunarMonths['ផល្គុន']!;
    }
    if (khmerMonth == Constant.lunarMonths['ផល្គុន']) {
      return Constant.lunarMonths['ចេត្រ']!;
    }
    if (khmerMonth == Constant.lunarMonths['ចេត្រ']) {
      return Constant.lunarMonths['ពិសាខ']!;
    }
    if (khmerMonth == Constant.lunarMonths['ពិសាខ']) {
      return Constant.lunarMonths['ជេស្ឋ']!;
    }
    if (khmerMonth == Constant.lunarMonths['ជេស្ឋ']) {
      if (_isKhmerLeapMonth(beYear)) {
        return Constant.lunarMonths['បឋមាសាឍ']!;
      } else {
        return Constant.lunarMonths['អាសាឍ']!;
      }
    }
    if (khmerMonth == Constant.lunarMonths['អាសាឍ']) {
      return Constant.lunarMonths['ស្រាពណ៍']!;
    }
    if (khmerMonth == Constant.lunarMonths['ស្រាពណ៍']) {
      return Constant.lunarMonths['ភទ្របទ']!;
    }
    if (khmerMonth == Constant.lunarMonths['ភទ្របទ']) {
      return Constant.lunarMonths['អស្សុជ']!;
    }
    if (khmerMonth == Constant.lunarMonths['អស្សុជ']) {
      return Constant.lunarMonths['កក្ដិក']!;
    }
    if (khmerMonth == Constant.lunarMonths['កក្ដិក']) {
      return Constant.lunarMonths['មិគសិរ']!;
    }
    if (khmerMonth == Constant.lunarMonths['បឋមាសាឍ']) {
      return Constant.lunarMonths['ទុតិយាសាឍ']!;
    }
    if (khmerMonth == Constant.lunarMonths['ទុតិយាសាឍ']) {
      return Constant.lunarMonths['ស្រាពណ៍']!;
    }
    throw Exception('Invalid month');
  }

  /// A year with an extra month is called Adhikameas (អធិកមាស). This year has 384 days.
  ///
  /// @param beYear
  /// @returns {boolean}
  static bool _isKhmerLeapMonth(int beYear) {
    return _getProtetinLeap(beYear) == 1;
  }

  // រកថ្ងៃវិសាខបូជា
  // ថ្ងៃដាច់ឆ្នាំពុទ្ធសករាជ
  static DateTime _getVisakhaBochea(int gregorianYear) {
    DateTime date = DateTime(gregorianYear, 1, 1, 0, 0, 0, 0);
    for (int i = 0; i < 365; i++) {
      LunarDate lunarDate = _findLunarDate(date);
      if (Constant.lunarMonths['ពិសាខ'] == lunarDate.month &&
          lunarDate.day == 14) {
        return date;
      }
      date = date.add(const Duration(days: 1));
    }
    throw Exception("Cannot find Visakhabochea day.");
  }
}

class LunarDate {
  final int day;
  final int month;
  final DateTime epochMoved;

  LunarDate({
    required this.day,
    required this.month,
    required this.epochMoved,
  });
}

class LunarDay {
  /// ថ្ងៃជាលេខបារាំង
  final int moonCount;

  /// លេខសម្គាល់ 0 : កើត , 1 : រោច
  final int moonStatus;

  /// ថ្ងៃជាលេខខ្មែរ
  final String moonCountKh;

  /// កើត , រោច
  final String moonStatusKh;

  LunarDay({
    required this.moonCount,
    required this.moonStatus,
    required this.moonCountKh,
    required this.moonStatusKh,
  });
}
