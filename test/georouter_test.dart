import 'package:flutter_test/flutter_test.dart';
import 'package:georouter/georouter.dart';
void main() {
  group('GeoRouter tests', () {
    late GeoRouter router;

    setUp(() {
      router = GeoRouter(mode: TravelMode.driving);
    });

    test('getDirectionsBetweenPoints returns valid polyline', () async {
      // Define a list of polyline points to use as coordinates
      final coordinates = [
        PolylinePoint(latitude: 40.748817, longitude: -73.985428),
        PolylinePoint(latitude: 40.729029, longitude: -73.996584),
        PolylinePoint(latitude: 40.705628, longitude: -74.013442),
        PolylinePoint(latitude: 40.745494, longitude: -73.988507),
      ];

      // Call the getDirectionsBetweenPoints method to retrieve a list of polyline points
      final polyline = await router.getDirectionsBetweenPoints(coordinates);

      // Verify that the result is not null and contains more than one point
      expect(polyline, isNotNull);
      expect(polyline.length, greaterThan(1));
    });

    test('getDirectionsBetweenPoints throws exception on invalid coordinates', () async {
      // Define an empty list of coordinates
      final List<PolylinePoint> coordinates = [];

      // Call the getDirectionsBetweenPoints method with invalid coordinates
      expect(() async => await router.getDirectionsBetweenPoints(coordinates), throwsA(isA<GeoRouterException>()));
    });
  });
}