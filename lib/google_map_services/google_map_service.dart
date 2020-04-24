import 'dart:convert';
import 'dart:math';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:http/http.dart' as http;
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/styles/uuid.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapServices {
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: AppM3alemKeys.apiKey2);
  GoogleDistanceMatrix _googleDistanceMatrix =
      GoogleDistanceMatrix(apiKey: AppM3alemKeys.apiKey2);

  final _uuid = Uuid();

  String get _apiKey => AppM3alemKeys.apiKey;
  String get _apiKeySecond => AppM3alemKeys.apiKey2;

  String get sessionToken => _uuid.generateV4();

  Future<double> getDistanceFromLatLng(LatLng from, LatLng to) async {
    final double distance = await Geolocator().distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
    return distance;
  }

  Future<List<Place>> getSuggestions(String query) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=$_apiKey&type=$type&language=en&components=country:ng&sessiontoken=$sessionToken';
    String url1 =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&language=fr&key=$_apiKeySecond&sessiontoken=$sessionToken';
    //print('Autocomplete(sessionToken): $sessionToken');

    final  response = await http.get(url1);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<String> getLocationNameByLatLng({LatLng latLng}) async {
    try {
      final String baseUrl =
          'https://maps.googleapis.com/maps/api/geocode/json';
      final String url =
          "$baseUrl?latlng=${latLng.latitude},${latLng.longitude}&key=$_apiKeySecond";

      final  response = await http.get(url);
      final responseData = json.decode(response.body);
      final result = responseData['results'][0]["formatted_address"] as String;

      return result;
    } catch (e) {
      return "${latLng.latitude},${latLng.longitude}";
    }
  }

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=$_apiKeySecond&place_id=$placeId&language=en&sessiontoken=$sessionToken';

    print('Place Detail(sessionToken): $sessionToken');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    print(placeDetail.toMap());

    return placeDetail;
  }

  Future<List<LatLng>> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$_apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    final val = values["routes"][0]["overview_polyline"]["points"];
    final result = _decodeEncodedPolyline(val);
    return result;
  }

  Future<DistanceResponse> getDistance(LatLng from, LatLng to) async {
    List<Location> origin =
        List<Location>.from([Location(from.latitude, from.longitude)]);
    List<Location> destination =
        List<Location>.from([Location(to.latitude, to.longitude)]);
    DistanceResponse distanceResponse =
        await _googleDistanceMatrix.distanceWithLocation(
      origin,
      destination,
      travelMode: TravelMode.driving,
    );
    return distanceResponse;
  }

  Future<List<LatLng>> getPolyline(LatLng from, LatLng to) async {
    final result = await googleMapPolyline.getCoordinatesWithLocation(
      origin: from,
      destination: to,
      mode: RouteMode.driving,
    );
    return result;
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
