import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapServie {
  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    // Convert latitude and longitude from degrees to radians
    lat1 = degreesToRadians(lat1);
    lon1 = degreesToRadians(lon1);
    lat2 = degreesToRadians(lat2);
    lon2 = degreesToRadians(lon2);

    // Calculate the difference in longitudes
    double deltaLon = lon2 - lon1;

    // Calculate the bearing using the atan2 function
    double theta = atan2(sin(deltaLon) * cos(lat2),
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon));

    // Convert the bearing from radians to degrees
    double bearing = radiansToDegrees(theta);

    // Ensure the bearing is between 0 and 360 degrees
    // bearing = (bearing + 360) % 360;

    return bearing;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  double radiansToDegrees(double radians) {
    return radians * (180.0 / pi);
  }

  List<LatLng> findMidpointsWithExactNo(LatLng start, LatLng end, int n) {
    List<LatLng> midpoints = [];

    final double latDiff = (end.latitude - start.latitude) / (n + 1);
    final double lngDiff = (end.longitude - start.longitude) / (n + 1);

    for (int i = 1; i <= n; i++) {
      final double midLat = start.latitude + i * latDiff;
      final double midLng = start.longitude + i * lngDiff;
      midpoints.add(LatLng(midLat, midLng));
    }
    midpoints.add(end);
    return midpoints;
  }

  List<LatLngBounds> findMidBounds(
      LatLngBounds bounds1, LatLngBounds bounds2, int n) {
    if (n < 1) {
      throw ArgumentError("The number of midpoints (n) must be at least 1.");
    }

    List<LatLngBounds> midBounds = [];

    for (int i = 0; i <= n; i++) {
      double ratio = i / n;
      LatLngBounds midpoint = LatLngBounds(
        LatLng(
          bounds1.southWest.latitude +
              ratio * (bounds2.southWest.latitude - bounds1.southWest.latitude),
          bounds1.southWest.longitude +
              ratio *
                  (bounds2.southWest.longitude - bounds1.southWest.longitude),
        ),
        LatLng(
          bounds1.northEast.latitude +
              ratio * (bounds2.northEast.latitude - bounds1.northEast.latitude),
          bounds1.northEast.longitude +
              ratio *
                  (bounds2.northEast.longitude - bounds1.northEast.longitude),
        ),
      );
      midBounds.add(midpoint);
    }
    midBounds.add(bounds2);
    return midBounds;
  }

  Future<void> animateBounds(
      {required LatLngBounds fromBound,
      required LatLngBounds toBound,
      required MapController mapController,
      double? padding}) async {
    double boundPadding = padding ?? 100;

    List<LatLngBounds> midBounds = findMidBounds(fromBound, toBound, 15);
    for (var bound in midBounds) {
      mapController.fitBounds(bound,
          options: FitBoundsOptions(padding: EdgeInsets.all(boundPadding)));
      await Future.delayed(const Duration(milliseconds: 25));
    }
    mapController.move(
        LatLng(mapController.center.latitude + 0.00000001,
            mapController.center.longitude + 0.00000001),
        mapController.zoom);
  }

  Future<void> animateLatlng(
      {required AnimationController animationController,
      required LatLng fromLatlng,
      required LatLng toLatlng,
      required MapController mapController,
      required double zoom,
      VoidCallback? then}) async {
    print('hello');
    Animation<double> latAnimation =
        Tween<double>(begin: fromLatlng.latitude, end: toLatlng.latitude)
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.easeInToLinear));

    Animation<double> longAnimation =
        Tween<double>(begin: fromLatlng.longitude, end: toLatlng.longitude)
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.easeInToLinear));

    Animation<double> zoomAnimation =
        Tween<double>(begin: mapController.camera.zoom, end: zoom).animate(
            CurvedAnimation(
                parent: animationController, curve: Curves.easeInToLinear));
    animationController.reset();
    animationController.forward().then((value) {
      if (then != null) {
        then();
      }
    });
    animationController.addListener(() {
      mapController.move(
          LatLng(latAnimation.value, longAnimation.value), zoomAnimation.value);
    });
  }
}
