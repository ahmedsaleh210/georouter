# GeoRouter

[![pub package](https://img.shields.io/pub/v/georouter.svg)](https://pub.dev/packages/geocoding_resolver)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![stars](https://img.shields.io/github/stars/ahmedsaleh210/georouter)

GeoRouter is a Flutter package that provides an easy-to-use API to request directions between points using OpenStreetMap Route Service Machine (OSRM).

## Features
Features:

- Request directions between two or more points using different travel modes (driving, walking, cycling, or transit).
- Decode polylines returned by OSRM into a list of latitude/longitude points.
- Handles errors and exceptions thrown by OSRM.

## Getting Started
1. Add the following to your pubspec.yaml file:
In your pubspec.yaml file, add the following dependency:
```yaml
dependencies:
  georouter: <lastest>
```

2. Import the package
```dart
import 'package:georouter/georouter.dart';
```

3. Use package:
```dart
final georouter = GeoRouter(mode: TravelMode.driving);

final coordinates = [
  PolylinePoint(latitude: 51.5074, longitude: -0.1278), // London, UK
  PolylinePoint(latitude: 48.8566, longitude: 2.3522), // Paris, France
];

try {
final directions = await georouter.getDirectionsBetweenPoints(coordinates);
// Do something with the directions
} on GeoRouterException catch (e) {
// Handle GeoRouterException
} on HttpException catch (e) {
// Handle HttpException
}
```

## Dependencies
```yaml
http: ^0.13.5
```