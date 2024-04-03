import 'package:khmer_chhankitek/khmer_chhankitek.dart';

class KhmerNewYearCal {
  final int jsYear;
  late final YearInfo info = getInfo(jsYear);
  late final KhmerNewYear khmerNewYear = KhmerNewYear(
    harkun: info.harkun,
    kromathopol: info.kromathopol,
    avaman: info.avaman,
    bodithey: info.bodithey,
    has366day: getHas366day(jsYear),
    isAthikameas: getIsAthikameas(jsYear),
    isChantreathimeas: getIsChantreathimeas(jsYear),
    jesthHas30: jesthHas30(jsYear),
    dayLerngSak: getDayLerngSak(),
    lunarDateLerngSak: getLunarDateLerngSak(),
    newYearsDaySotins: getNewYearDaySotins(),
    timeOfNewYear: getNewYearTime(),
  );

  KhmerNewYearCal({required this.jsYear});

  //  គណនា ហារគុន Kromathopol អវមាន និង បូតិថី
  YearInfo getInfo(int jsYear) {
    int h = 292207 * jsYear + 373;
    // 800 days
    int harkun = (h / 800).floor() + 1;
    int kromathopol = 800 - (h % 800);

    int a = (11 * harkun) + 650;
    int avaman = a % 692;
    // 692 days
    int bodithey = (harkun + (a / 692).floor()) % 30;
    return YearInfo(
      harkun: harkun,
      kromathopol: kromathopol,
      avaman: avaman,
      bodithey: bodithey,
    );
  }

  // ឆ្នាំចុល្លសករាជដែលមាន៣៦៦ថ្ងៃ
  bool getHas366day(int jsYear) {
    YearInfo infoOfYear = getInfo(jsYear);
    return infoOfYear.kromathopol <= 207;
  }

  // រកឆ្នាំអធិកមាស
  bool getIsAthikameas(int jsYear) {
    YearInfo infoOfYear = getInfo(jsYear);
    YearInfo infoOfNextYear = getInfo((jsYear + 1));
    return (!(infoOfYear.bodithey == 25 && infoOfNextYear.bodithey == 5) &&
        (infoOfYear.bodithey > 24 ||
            infoOfYear.bodithey < 6 ||
            (infoOfYear.bodithey == 24 && infoOfNextYear.bodithey == 6)));
  }

  // រកឆ្នាំចន្ទ្រាធិមាស
  bool getIsChantreathimeas(int jsYear) {
    YearInfo infoOfYear = getInfo(jsYear);
    YearInfo infoOfNextYear = getInfo((jsYear + 1));
    YearInfo infoOfPreviousYear = getInfo(jsYear);
    bool has366day = getHas366day(jsYear);
    return ((has366day && infoOfYear.avaman < 127) ||
        (!(infoOfYear.avaman == 137 && infoOfNextYear.avaman == 0) &&
            ((!has366day && infoOfYear.avaman < 138) ||
                (infoOfPreviousYear.avaman == 137 && infoOfYear.avaman == 0))));
  }

  // ឆែកមើលថាជាឆ្នាំដែលខែជេស្ឋមាន៣០ថ្ងៃឬទេ
  bool jesthHas30(int jsYear) {
    bool tmp = getIsChantreathimeas(jsYear);
    if (getIsAthikameas(jsYear) && getIsChantreathimeas(jsYear)) {
      tmp = false;
    }
    if (!getIsChantreathimeas(jsYear) &&
        getIsAthikameas(jsYear - 1) &&
        getIsChantreathimeas(jsYear - 1)) {
      tmp = true;
    }
    return tmp;
  }

  // រកមើលថាតើថ្ងៃឡើងស័កចំថ្ងៃអ្វី
  int getDayLerngSak() {
    return (info.harkun - 2) % 7;
  }

  // គណនារកថ្ងៃឡើងស័ក
  LunarDateLerngSak getLunarDateLerngSak() {
    int bodithey = info.bodithey;
    if (getIsAthikameas(jsYear - 1) && getIsChantreathimeas(jsYear - 1)) {
      bodithey = (bodithey + 1) % 30;
    }
    return LunarDateLerngSak(
        day: bodithey >= 6 ? (bodithey - 1) : bodithey,
        month: bodithey >= 6
            ? Constant.lunarMonths['ចេត្រ']!
            : Constant.lunarMonths['ពិសាខ']!);
  }

  List<NewYearDaySotins> getNewYearDaySotins() {
    // ចំនួនថ្ងៃវ័នបត
    List<int> sotins = getHas366day(jsYear - 1)
        ? <int>[363, 364, 365, 366]
        : <int>[362, 363, 364, 365]; // សុទិន
    List<NewYearDaySotins> newYearDaySotins = <NewYearDaySotins>[];
    for (int i in sotins) {
      SunInfo sunInfo = getSunInfo(i);
      // 30 days * 60 days
      int reasey = (sunInfo.sunInaugurationAsLibda / (30 * 60)).floor();
      // 30 days * 60 days
      // អង្សាស្មើសូន្យ គីជាថ្ងៃចូលឆ្នាំ, មួយ ឬ ពីរ
      int angsar =
          ((sunInfo.sunInaugurationAsLibda % (30 * 60)) / (60)).floor();
      // ថ្ងៃបន្ទាប់ជាថ្ងៃវ័នបត ហើយ ថ្ងៃចុងក្រោយគីឡើងស័ក
      int libda = sunInfo.sunInaugurationAsLibda % 60;
      newYearDaySotins.add(NewYearDaySotins(
          sotin: i, reasey: reasey, angsar: angsar, libda: libda));
    }
    return newYearDaySotins;
  }

  NewYearTime getNewYearTime() {
    List<NewYearDaySotins> sotinNewYear =
        getNewYearDaySotins().where((element) => element.angsar == 0).toList();
    if (sotinNewYear.isNotEmpty) {
      int libda = sotinNewYear[0].libda; // ២៤ ម៉ោង មាន ៦០លិប្ដា
      int minutes = (24 * 60) - (libda * 24);
      // 60 days
      return NewYearTime(hour: (minutes / 60).floor(), minute: (minutes % 60));
    } else {
      throw Exception(
          "Wrong calculation on new years hour. No sotin with angsar = 0");
    }
  }

  SunInfo getSunInfo(int sotin) {
    // សុទិន
    YearInfo infoOfPreviousYear = getInfo(jsYear - 1);
    // ១ រាសី = ៣០ អង្សា
    // ១ អង្សា = ៦០ លិប្ដា
    // មធ្យមព្រះអាទិត្យ គិតជាលិប្ដា
    int sunAverageAsLibda = getSunAverageAsLibda(sotin, infoOfPreviousYear);

    int leftOver = getLeftOver(sunAverageAsLibda);
    // 30 days * 60 days
    int kaen = (leftOver / (30 * 60)).floor();

    LastOver lastLeftOver = getLastLeftOver(kaen, leftOver);

    // ខណ្ឌ និង pouichalip
    int khan = 0;
    int pouichalip = 0;

    if (lastLeftOver.angsar >= 15) {
      khan = 2 * lastLeftOver.reasey + 1;
      pouichalip = 60 * (lastLeftOver.angsar - 15) + lastLeftOver.libda;
    } else {
      khan = 2 * lastLeftOver.reasey;
      pouichalip = 60 * lastLeftOver.angsar + lastLeftOver.libda;
    }

    // phol
    Phol phol = getPhol(khan, pouichalip);

    int sunInaugurationAsLibda = 0; // សម្ពោធព្រះអាទិត្យ
    int pholAsLibda = (30 * 60 * phol.reasey) + (60 * phol.angsar) + phol.libda;
    if (kaen <= 5) {
      sunInaugurationAsLibda = sunAverageAsLibda - pholAsLibda;
    } else {
      sunInaugurationAsLibda = sunAverageAsLibda + pholAsLibda;
    }
    return SunInfo(
        sunAverageAsLibda: sunAverageAsLibda,
        khan: khan,
        pouichalip: pouichalip,
        phol: phol,
        sunInaugurationAsLibda: sunInaugurationAsLibda);
  }

  Phol getPhol(int khan, int pouichalip) {
    int multiplicity = 0;
    int chhaya = 0;
    List<int> multiplicities = [35, 32, 27, 22, 13, 5];
    List<int> chhayas = [0, 35, 67, 94, 116, 129];

    switch (khan) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        multiplicity = multiplicities[khan];
        chhaya = chhayas[khan];
        break;
      default:
        chhaya = 134;
        break;
    }
    // 900 days
    int q = ((pouichalip * multiplicity) / 900).floor();

    // 60 days
    return Phol(
        reasey: 0,
        angsar: ((q + chhaya) / 60).floor(),
        libda: (q + chhaya) % 60);
  }

  int getSunAverageAsLibda(int sotin, YearInfo info) {
    int r2 = 800 * sotin + info.kromathopol;
    // 24350 days
    int reasey = (r2 / 24350).floor(); // រាសី
    int r3 = r2 % 24350;
    // 811 days
    int angsar = (r3 / 811).floor(); // អង្សា
    int r4 = r3 % 811;
    // 14 days
    int l1 = (r4 / 14).floor();
    int libda = l1 - 3; // លិប្ដា
    return (30 * 60 * reasey) + (60 * angsar) + libda;
  }

  int getLeftOver(int sunAverageAsLibda) {
    int s1 = ((30 * 60 * 2) + (60 * 20));
    int leftOver = sunAverageAsLibda - s1; // មធ្យមព្រះអាទិត្យ - R2.A20.L0
    if (sunAverageAsLibda < s1) {
      // បើតូចជាង ខ្ចី ១២ រាសី
      leftOver += (30 * 60 * 12);
    }
    return leftOver;
  }

  LastOver getLastLeftOver(int kaen, int leftOver) {
    int rs = -1;
    List<int> l1 = [0, 1, 2];
    List<int> l2 = [3, 4, 5];
    List<int> l3 = [6, 7, 8];
    List<int> l4 = [9, 10, 11];
    if (l1.contains(kaen)) {
      rs = kaen;
    } else if (l2.contains(kaen)) {
      rs = (30 * 60 * 6) - leftOver; // R6.A0.L0 - leftover
    } else if (l3.contains(kaen)) {
      rs = leftOver - (30 * 60 * 6); // leftover - R6.A0.L0
    } else if (l4.contains(kaen)) {
      rs = ((30 * 60 * 11) + (60 * 29) + 60) -
          leftOver; // R11.A29.L60 - leftover
    }
    // 30 days * 60 days
    return LastOver(
      reasey: (rs / (30 * 60)).floor(),
      angsar: ((rs % (30 * 60)) / (60)).floor(),
      libda: rs % 60,
    );
  }
}

class YearInfo {
  final int harkun;
  final int kromathopol;
  final int avaman;
  final int bodithey;

  YearInfo({
    required this.harkun,
    required this.kromathopol,
    required this.avaman,
    required this.bodithey,
  });
}

class KhmerNewYear {
  final int harkun;
  final int kromathopol;
  final int avaman;
  final int bodithey;
  final bool has366day; // សុរិយគតិខ្មែរ
  final bool isAthikameas; // 13 months
  final bool isChantreathimeas; // 30ថ្ងៃនៅខែជេស្ឋ
  final bool jesthHas30; // ខែជេស្ឋមាន៣០ថ្ងៃ
  final int dayLerngSak; // ថ្ងៃឡើងស័ក ច័ន្ទ អង្គារ ...
  final LunarDateLerngSak lunarDateLerngSak; // ថ្ងៃទី ខែ ឡើងស័ក
  final List<NewYearDaySotins>
      newYearsDaySotins; // សុទិនសម្រាប់គណនាថ្ងៃចូលឆ្នាំ ថ្ងៃវ័នបត និង ថ្ងៃឡើងស័ក
  final NewYearTime timeOfNewYear; // ម៉ោងទេវតាចុះ

  KhmerNewYear({
    required this.harkun,
    required this.kromathopol,
    required this.avaman,
    required this.bodithey,
    required this.has366day,
    required this.isAthikameas,
    required this.isChantreathimeas,
    required this.jesthHas30,
    required this.dayLerngSak,
    required this.lunarDateLerngSak,
    required this.newYearsDaySotins,
    required this.timeOfNewYear,
  });
}

class LunarDateLerngSak {
  final int day;
  final int month;

  LunarDateLerngSak({required this.day, required this.month});
}

class NewYearDaySotins {
  final int sotin;
  final int reasey;
  final int angsar;
  final int libda;

  NewYearDaySotins({
    required this.sotin,
    required this.reasey,
    required this.angsar,
    required this.libda,
  });
}

class NewYearTime {
  final int hour;
  final int minute;

  NewYearTime({
    required this.hour,
    required this.minute,
  });
}

class SunInfo {
  final int sunAverageAsLibda;
  final int khan;
  final int pouichalip;
  final Phol phol;
  final int sunInaugurationAsLibda;

  SunInfo(
      {required this.sunAverageAsLibda,
      required this.khan,
      required this.pouichalip,
      required this.phol,
      required this.sunInaugurationAsLibda});
}

class Phol {
  final int reasey;
  final int angsar;
  final int libda;

  Phol({
    required this.reasey,
    required this.angsar,
    required this.libda,
  });
}

class LastOver {
  final int reasey;
  final int angsar;
  final int libda;

  LastOver({
    required this.reasey,
    required this.angsar,
    required this.libda,
  });
}
