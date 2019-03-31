import 'package:geotools/geotools.dart';
import 'package:test/test.dart';

void main() {
  group('latLongAsJson', () {
    test('argumentErrors', () {
      expect(() => latLongAsJsonString(-91, 0), throwsArgumentError);
      expect(() => latLongAsJsonString(91, 0), throwsArgumentError);
      expect(() => latLongAsJsonString(0, -181), throwsArgumentError);
      expect(() => latLongAsJsonString(0, 181), throwsArgumentError);
      expect(() => latLongAsJsonString(0, null), throwsArgumentError);
      expect(() => latLongAsJsonString(null, 0), throwsArgumentError);
    });
    test('latLongAsJson', () {
      expect(latLongAsJsonString(0, 0), equals('{"lat":0.0,"long":0.0}'));
    });
  });

  group('node', () {
    test('argumentErrors', () {
      expect(() => nodeAsJsonString(null, 0, 0), throwsArgumentError);
      expect(() => nodeAsJsonString(-1, 0, 0), throwsArgumentError);
    });
    test('node', () {
      expect(nodeAsJsonString(0, 0, 0),
          equals('{"id":0,"latLong":{"lat":0.0,"long":0.0}}'));
    });
  });
}
