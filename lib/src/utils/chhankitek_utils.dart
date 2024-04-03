import 'package:khmer_chhankitek/khmer_chhankitek.dart';

class ChhankitekUtils {
  static Map<int, T> indexAsKeyMap<T>({required List<T> values}) {
    Map<int, T> map = {};
    for (int index = 0; index < values.length; index++) {
      map[index] = values[index];
    }
    return map;
  }

  static Map<T, int> indexAsValueMap<T>({required List<T> values}) {
    Map<T, int> map = {};
    for (int index = 0; index < values.length; index++) {
      map[values[index]] = index;
    }
    return map;
  }

  static String convertIntegerToKhmerNumber(int number) {
    String result = "";
    String num = number.toString();
    for (int i = 0; i < num.length; i++) {
      String c = num[i];
      result += Constant.numbers[c]!;
    }
    return result;
  }

  static String getDayOfWeekInKhmer(DateTime dateTime) {
    int dayOfWeek = dateTime.weekday;
    return Constant.dayOfWeek[dayOfWeek]!;
  }
}
