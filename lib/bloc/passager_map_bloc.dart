import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:location/location.dart';

import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/course_repository.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/socket/socket_service_passager.dart';
import 'package:m3alem/utils/utilis_fonctions.dart';

import '../m3alem_keys.dart';

part 'passager_map_event.dart';
part 'passager_map_state.dart';

class PassagerMapBloc extends Bloc<PassagerMapEvent, PassagerMapState> {
  AuthentificationBloc authentificationBloc;
  SugestionBloc sugestionBloc;

  Location _location = new Location();

  GoogleMapServices googleMapServices = GoogleMapServices();

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng _fromLatLng;
  LatLng _toLatLng;
  final _toMarkerId = MarkerId("__destination__");
  final _fromMarkerId = MarkerId("__depart__");

  BitmapDescriptor _destinationIcon;
  SocketServicePassager socket;
  UtilisateurRepository utilisateurRepository;
  CourseRespository courseRespository;

  Course _course;

  PassagerMapBloc({
    @required this.authentificationBloc,
    @required this.sugestionBloc,
    @required this.socket,
    @required this.courseRespository,
    @required this.utilisateurRepository,
  }) {
    _initSocket();
  }
  LocationData _locationData;
  @override
  PassagerMapState get initialState => PassagerMapInitial();

  @override
  Stream<PassagerMapState> mapEventToState(
    PassagerMapEvent event,
  ) async* {
    if (event is DisplayPassagerMap)
      yield* _mapDisplayPassagerMapToState(event: event);
    else if (event is LongPress) {
      yield* _mapLongPressToState(event);
    }
  }

  Stream<PassagerMapState> _mapLongPressToState(LongPress event) async* {
    if (event.source == MarkerDragSourse.to)
      _toLatLng = event.latLng;
    else
      _fromLatLng = event.latLng;
    _updateMarker();
    yield* _updatePassagerMap();
  }

  Stream<PassagerMapState> _updatePassagerMap() async* {
    yield (state as PassagerMapLoaded).copyWith(isLoading: true);

    String _toText;
    String _fromText;
    if (_toLatLng != null) {
      _toText =
          await googleMapServices.getLocationNameByLatLng(latLng: _toLatLng);
    }
    if (_fromLatLng != null) {
      _fromText =
          await googleMapServices.getLocationNameByLatLng(latLng: _fromLatLng);
    }
    //await _updatePolilyne(); // va demander les info depuis google api
    final polyl = await _getPolilyne(_fromLatLng, _toLatLng);
    double distance;
    if (polyl.isNotEmpty) {
      // calculer la distance des deux points
      distance = calculDistanceCourse(polyl.first.points);
    }

    yield PassagerMapLoaded(
      isLoading: false,
      from: _fromLatLng,
      to: _toLatLng,
      toTxt: _toText,
      fromTxt: _fromText,
      markers: _markers,
      polyLines: polyl,
      distance: distance,
    );
  }

  Stream<PassagerMapState> _mapDisplayPassagerMapToState(
      {DisplayPassagerMap event}) async* {
    _fromLatLng = await _getLocation();
    await _loadIcons();
    _updateMarker();
    yield PassagerMapLoaded(from: _fromLatLng, markers: _markers);
  }

  _updateMarker({Marker marker}) {
    //markers.removeWhere((m) => m.markerId == marker.markerId);
    final from = _getFromMarker();
    final to = _getToMarker();
    _markers.clear();
    if (from != null) _markers.add(from);
    if (to != null) _markers.add(to);
  }

  Future<void> _updatePolilyne() async {
    _polylines.clear();
    List<LatLng> latLngs =
        await googleMapServices.getPolyline(_fromLatLng, _toLatLng);
    _polylines.add(
      Polyline(
        polylineId: PolylineId('__cource__'),
        width: 10,
        points: latLngs,
        color: Colors.black,
      ),
    );
  }

  Future<Set<Polyline>> _getPolilyne(LatLng fromLatLng, LatLng toLatLng) async {
    List<LatLng> latLngs =
        await googleMapServices.getPolyline(_fromLatLng, _toLatLng);

    return Set<Polyline>.of([
      Polyline(
        polylineId: PolylineId('__cource__'),
        width: 10,
        points: latLngs,
        color: Colors.black,
      )
    ]);
  }

  Marker _getFromMarker() {
    return Marker(
      position: _fromLatLng,
      markerId: _fromMarkerId,
      // icon: ,
      draggable: true,
      onDragEnd: (LatLng latLng) =>
          add(LongPress(latLng: latLng, source: MarkerDragSourse.from)),
      infoWindow: InfoWindow(
        title: "Depart de la course",
      ),
      onTap: () {},
    );
  }

  Marker _getToMarker() {
    return _toLatLng != null
        ? Marker(
            markerId: _toMarkerId,
            position: _toLatLng,
            icon: _destinationIcon,
            draggable: true,
            onDragEnd: (LatLng latLng) =>
                add(LongPress(latLng: latLng, source: MarkerDragSourse.to)),
            infoWindow: InfoWindow(
              title: "Destination",
            ),
          )
        : null;
  }

  Future<LatLng> _getLocation() async {
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

  _loadIcons() async {
    if (_destinationIcon == null) {
      _destinationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            devicePixelRatio: 2.5,
          ),
          'assets/img/destination.png');
    }
  }

  Future<List<Place>> getSuggestions(String pattern) async {
    return await googleMapServices.getSuggestions(pattern);
  }

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    return await googleMapServices.getPlaceDetail(placeId);
  }

  LatLng get currentPosition => _fromLatLng;

  _initSocket() {
    if (!socket.hastInit)
      socket.initSocket(
        onSuccess: (_, __) {
          add(PassagerOnLineOk());
        },
        errorSocket: (_) {
          add(PassagerOnLineKo());
        },
      );
  }
}
