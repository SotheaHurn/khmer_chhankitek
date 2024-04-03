# Khmer Chhankitek

Introducing the Khmer Calendar Package, a comprehensive tool for integrating Khmer lunar and solar calendar functionalities into your Dart and Flutter projects. This package provides developers with easy-to-use methods to convert between Khmer and Gregorian dates, display traditional Khmer dates in your app, and calculate important Khmer holidays and festivals. Seamlessly incorporate Khmer cultural elements into your applications with this essential package. Simplify Khmer date management and enhance user experience with the Khmer Calendar Package, now available on pub.dev.

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies.

```yaml
dependencies:
  khmer_chhankitek: ^0.0.3
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
Chhankitek.now().toString();
```

### Get a Specific Date

```dart
Chhankitek.get(DateTime(2024, 4, 12)).toString();
Chhankitek.get(DateTime(2025, 2, 25)).toString();
```

### Other Methods

```dart
Chhankitek.now().dayOfWeek;
Chhankitek.now().lunarDay;
Chhankitek.now().lunarMonth;
Chhankitek.now().lunarZodiac;
Chhankitek.now().lunarEra;
Chhankitek.now().lunarYear;
Chhankitek.now().solarDay;
Chhankitek.now().solarMonth;
Chhankitek.now().solarYear;
```
