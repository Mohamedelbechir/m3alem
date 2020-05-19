import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/** 
 * pour arrondir un nombre 
 * */
String arrondir(String valeur, {int limit = 3}) {
  final vls = valeur.split('.');
  final res = vls[0] + "," + vls[1].substring(0, limit);
  return res;
}

LatLng stringToLatLng(String latLng) {
  final res = latLng.split(';');
  return LatLng(double.parse(res.elementAt(0)), double.parse(res.elementAt(1)));
}

String latLngToString(LatLng latLng) =>
    "${latLng.latitude}; ${latLng.longitude}";

CameraPosition getCameraPosition({LatLng latLng}) {
  return CameraPosition(
    bearing: 192.8334901395799,
    target: latLng,
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );
}

double calculDistanceCourse(List<LatLng> poly) {
  double calculTwoLatLng(LatLng latLng1, LatLng latLng2) {
    final p = 0.017453292519943295;
    final c = cos;
    final a = 0.5 -
        c((latLng2.latitude - latLng1.latitude) * p) / 2 +
        c(latLng1.latitude * p) *
            c(latLng2.latitude * p) *
            (1 - c((latLng2.longitude - latLng1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  double totalDistance = 0;
  for (var i = 0; i < poly.length - 1; i++) {
    totalDistance += calculTwoLatLng(poly[i], poly[i + 1]);
  }
  return totalDistance;
}
