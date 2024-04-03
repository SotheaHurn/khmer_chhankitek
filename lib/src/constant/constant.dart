import 'package:khmer_chhankitek/khmer_chhankitek.dart';

class Constant {
  static final Map<String, String> numbers = {
    '0': '០',
    '1': '១',
    '2': '២',
    '3': '៣',
    '4': '៤',
    '5': '៥',
    '6': '៦',
    '7': '៧',
    '8': '៨',
    '9': '៩'
  };

  static final Map<int, String> dayOfWeek = {
    1: 'ច័ន្ទ',
    2: 'អង្គារ',
    3: 'ពុធ',
    4: 'ព្រហស្បតិ៍',
    5: 'សុក្រ',
    6: 'សៅរ៍',
    7: 'អាទិត្យ',
  };

  static final Map<String, int> lunarMonths =
      ChhankitekUtils.indexAsValueMap<String>(values: [
    'មិគសិរ',
    'បុស្ស',
    'មាឃ',
    'ផល្គុន',
    'ចេត្រ',
    'ពិសាខ',
    'ជេស្ឋ',
    'អាសាឍ',
    'ស្រាពណ៍',
    'ភទ្របទ',
    'អស្សុជ',
    'កក្ដិក',
    'បឋមាសាឍ',
    'ទុតិយាសាឍ',
  ]);

  static final Map<int, String> lunarMonthsFormat =
      ChhankitekUtils.indexAsKeyMap<String>(values: [
    'មិគសិរ',
    'បុស្ស',
    'មាឃ',
    'ផល្គុន',
    'ចេត្រ',
    'ពិសាខ',
    'ជេស្ឋ',
    'អាសាឍ',
    'ស្រាពណ៍',
    'ភទ្របទ',
    'អស្សុជ',
    'កក្ដិក',
    'បឋមាសាឍ',
    'ទុតិយាសាឍ',
  ]);

  static final Map<String, int> solarMonths =
      ChhankitekUtils.indexAsValueMap<String>(values: [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ]);

  static final Map<int, String> solarMonthsKh =
      ChhankitekUtils.indexAsKeyMap<String>(values: [
    'មករា',
    'កុម្ភៈ',
    'មីនា',
    'មេសា',
    'ឧសភា',
    'មិថុនា',
    'កក្កដា',
    'សីហា',
    'កញ្ញា',
    'តុលា',
    'វិច្ឆកា',
    'ធ្នូ',
  ]);

  static final Map<int, String> animalYear =
      ChhankitekUtils.indexAsKeyMap<String>(values: [
    'ជូត',
    'ឆ្លូវ',
    'ខាល',
    'ថោះ',
    'រោង',
    'ម្សាញ់',
    'មមីរ',
    'មមែ',
    'វក',
    'រកា',
    'ច',
    'កុរ',
  ]);

  static final Map<int, String> eraYear =
      ChhankitekUtils.indexAsKeyMap(values: [
    'សំរឹទ្ធិស័ក',
    'ឯកស័ក',
    'ទោស័ក',
    'ត្រីស័ក',
    'ចត្វាស័ក',
    'បញ្ចស័ក',
    'ឆស័ក',
    'សប្តស័ក',
    'អដ្ឋស័ក',
    'នព្វស័ក',
  ]);

  static final Map<String, int> moonStatus = {'កើត': 0, 'រោច': 1};

  static final Map<int, String> moonStatusKH = {0: 'កើត', 1: 'រោច'};
}
