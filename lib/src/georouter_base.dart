import 'dart:convert';

import 'package:http/http.dart' as http;
import 'models/exceptions.dart';
import 'models/point.dart';

enum TravelMode { driving, walking, cycling, transit }

class GeoRouter extends _GeoRouterService {
  final TravelMode mode;

  GeoRouter({required this.mode});

  Future<List<PolylinePoint>> getDirectionsBetweenPoints(
      List<PolylinePoint> coordinates) async {
    try {
      final polyLines = await _getDirections(coordinates);
      return polyLines;
    } catch (e) {
      rethrow;
    }
  }

  @override
  String _getTravelMode() {
    switch (mode) {
      case TravelMode.driving:
        return 'driving';
      case TravelMode.walking:
        return 'walking';
      case TravelMode.cycling:
        return 'cycling';
      case TravelMode.transit:
        return 'transit';
      default:
        return 'driving';
    }
  }
}

abstract class _GeoRouterService {
  static const String _baseUrl = 'router.project-osrm.org';
  static const String _path = '/route/v1';

  Future<List<PolylinePoint>> _getDirections(
      List<PolylinePoint> coordinates) async {
    final String coordinatesString = _getCoordinatesString(coordinates);
    final Uri url =
        Uri.https(_baseUrl, '$_path/${_getTravelMode()}/$coordinatesString');

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final geometry = jsonDecode(response.body)['routes'][0]['geometry'];
        final List<PolylinePoint> polylines = _decodePolyline(geometry);
        return polylines;
      } else {
        throw HttpException(response.statusCode);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } catch (e) {
      throw GeoRouterException('Failed to fetch directions: $e');
    }
  }

  String _getTravelMode();

  static String _getCoordinatesString(List<PolylinePoint> coordinates) {
    final List<String> coords = coordinates
        .map((point) => '${point.longitude},${point.latitude}')
        .toList();
    return coords.join(';');
  }

  static List<PolylinePoint> _decodePolyline(String encoded) {
    final List<PolylinePoint> points = <PolylinePoint>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final PolylinePoint point =
          PolylinePoint(latitude: lat / 1E5, longitude: lng / 1E5);
      points.add(point);
    }

    return points;
  }
}
