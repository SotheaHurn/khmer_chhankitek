# Khmer Chhankitek

Introducing the Khmer Calendar Package, a comprehensive tool for integrating Khmer lunar and solar calendar functionalities into your Dart and Flutter projects. This package provides developers with easy-to-use methods to convert between Khmer and Gregorian dates, display traditional Khmer dates in your app, and calculate important Khmer holidays and festivals. Seamlessly incorporate Khmer cultural elements into your applications with this essential package. Simplify Khmer date management and enhance user experience with the Khmer Calendar Package, now available on pub.dev.

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies.

```yaml
dependencies:
  khmer_chhankitek: ^0.0.4
```

## Import

Import the package with :

```dart
import 'package:khmer_chhankitek/khmer_chhankitek.dart';
```

## Usage

The usage is very simple :

### Get a Current Date

```dart
Chhankitek.now();
```

### Get a Specific Date

```dart
Chhankitek.get(DateTime(2024, 5, 12));

// use to string to khmer fomat
Chhankitek.get(DateTime(2025, 2, 12)).toString();
```

### Other Methods

```dart
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
```
