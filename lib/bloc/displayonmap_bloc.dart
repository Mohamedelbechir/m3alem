import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/models/freezed_classes.dart';

import 'package:m3alem/utils/utilis_fonctions.dart';

part 'displayonmap_event.dart';
part 'displayonmap_state.dart';

enum MyIconType { from, to }

class DisplayOnMapBloc extends Bloc<DisplayOnMapEvent, DisplayOnMapState> {
  final GoogleMapServices googleMapServices = GoogleMapServices();

  @override
  DisplayOnMapState get initialState => DisplayOnMapInitial();

  @override
  Stream<DisplayOnMapState> mapEventToState(
    DisplayOnMapEvent event,
  ) async* {
    if (event is DisplayOnMap) yield* _mapDispplayOnMapToState(event);
  }

  Stream<DisplayOnMapState> _mapDispplayOnMapToState(
      DisplayOnMap event) async* {
    try {
      final fromLg = stringToLatLng(event.course.latLngDepart);
      final toLg = stringToLatLng(event.course.latLngArrivee);
      final fromMarker = await _getMarker(
          name: "Depart", position: fromLg, type: MyIconType.from);
      final toMarker =
          await _getMarker(name: "Depart", position: toLg, type: MyIconType.to);
      List<LatLng> latLngs =
          await googleMapServices.getRouteCoordinates(fromLg, toLg);
      int k = 5;
      yield MapDisplayed(
        markers: {fromMarker, toMarker},
        polyLines: {
          Polyline(
            polylineId: PolylineId('__cource__'),
            width: 10,
            points: latLngs,
            color: Colors.black,
          ),
        },
        fromLatLng: fromLg,
        toLatLng: toLg,
      );
    } catch (e) {
      yield MapDisplayingError("Vérifier votre connexion");
    }
  }

  Future<Marker> _getMarker(
      {LatLng position, String name, MyIconType type}) async {
    final markerId = MarkerId(name);
    return Marker(
      position: position,
      markerId: markerId,
      icon: await _getIcon(type),
      draggable: true,
    );
  }

  Future<BitmapDescriptor> _getIcon(MyIconType type) async {
    final myPath = type == MyIconType.from
        ? 'assets/img/depart.png'
        : 'assets/img/destination.png';

    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        myPath);
    return icon;
  }
}
