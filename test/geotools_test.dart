import 'package:geotools/geotools.dart';
import 'package:test/test.dart';

void main() {
  group('latLongAsJson', () {
    test('argumentErrors', () {
      expect(() => latLongAsJson(-91, 0), throwsArgumentError);
      expect(() => latLongAsJson(91, 0), throwsArgumentError);
      expect(() => latLongAsJson(0, -181), throwsArgumentError);
      expect(() => latLongAsJson(0, 181), throwsArgumentError);
      expect(() => latLongAsJson(0, null), throwsArgumentError);
      expect(() => latLongAsJson(null, 0), throwsArgumentError);
    });
    test('latLongAsJson', () {
      expect(latLongAsJson(0, 0), equals('{"lat":0.0,"lon":0.0}'));
    });
  });
}
