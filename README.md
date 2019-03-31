A Dart library that provides tools for manipulating and working with geospatial data.

Created by BitFlippers, provided under a MIT
[license](https://github.com/bitflippers/dart-geotools/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:geotools/geotools.dart';

main() {

print(latLongAsJson(0,0));

}
```

## Inspired By

* https://www.dartlang.org/guides/language/effective-dart
* https://www.dartlang.org/guides/libraries/create-library-packages
* https://github.com/a14n/dart-geo
* https://github.com/MikeMitterer/dart-latlong/blob/master/lib/latlong/Path.dart
* https://github.com/llamadonica/dart-geohash/blob/master/lib/src/geohash_base.dart
* https://github.com/wingkwong/geodesy
* https://pub.dartlang.org/packages/geopoint
* https://pub.dartlang.org/documentation/shelf/latest/
* https://github.com/dart-lang/shelf
* https://www.dartlang.org/tools/pub/pubspec#version
* https://www.dartlang.org/guides/language/language-tour

## Development

* pub get
* dart --enable-asserts --enable-vm-service:49905 ./example/geotools_example.dart
* pub run test -r json ./test/geotools_test.dart