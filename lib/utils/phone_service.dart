import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PhoneService {
  static Location _location = new Location();
  static LocationData _locationData;

  static Future<LatLng> getLocation() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await _location.getLocation();
    _locationData.toString();

    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  static Future<BitmapDescriptor> loadBitmap(String fileName) async {
    final _icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/img/' + fileName);
    return _icon;
  }
}
