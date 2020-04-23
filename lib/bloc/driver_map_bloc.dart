import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/socket/socket.dart';
import 'package:m3alem/socket/socket_service_driver.dart';
import 'package:m3alem/utils/phone_service.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

part 'driver_map_event.dart';
part 'driver_map_state.dart';

class DriverMapBloc extends Bloc<DriverMapEvent, DriverMapState> {
  LatLng _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polyline;

  BitmapDescriptor _iconCar;

  UtilisateurRepository _utilisateurRepository;
  AuthentificationBloc _authentificationBloc;

  // SocketDriverService _socketDriverService;
  SocketServiceDriver _socket;
  DriverMapBloc({
    @required UtilisateurRepository utilisateurRepository,
    @required AuthentificationBloc authentificationBloc,
  }) : assert(utilisateurRepository != null) {
    _utilisateurRepository = utilisateurRepository;
    _authentificationBloc = authentificationBloc;
    //  _socketDriverService = SocketDriverService();
  }
  
  @override
  DriverMapState get initialState => DriverMapInitial();

  @override
  Stream<DriverMapState> mapEventToState(
    DriverMapEvent event,
  ) async* {
    if (event is DisplayDriverMap)
      yield* _mapDisplayPassagerMapToState();
    else if (event is SwichDriverState)
      yield* _mapSwichDriverStateToState(event);
    else if (event is DriverWaiting) {
      print("je suis en attente");
    }
    else if(event is DriverOnLine){
      print("je suis en ligne");
    }
  }

  Stream<DriverMapState> _mapDisplayPassagerMapToState() async* {
    try {
      _currentPosition = await PhoneService.getLocation();
      if (_iconCar == null) _iconCar = await PhoneService.loadBitmap('car.png');
      await _updateMarkers();

      yield DriverMapLoaded(
        currentLatLng: _currentPosition,
        markers: _markers,
        isOnLine: _currentUser.isOnLine,
      );
    } catch (e) {
      yield DriverMapLoadingFailed();
    }
  }

  Stream<DriverMapState> _mapSwichDriverStateToState(
      SwichDriverState event) async* {
    final result = await _utilisateurRepository.setOnline(
      _authentificationBloc.currentUser.cin,
      event.isOnLine,
    );
    _authentificationBloc
        .setCurrentUSer(_currentUser.copyWith(isOnLine: event.isOnLine));

   // if (_socket == null) _initSocket();

    if (event.isOnLine) {
      _socket.driverSubscribForWait(
        callback: (Course course) {
          // => reception de notification de course
          add(DriverCourseNotification(course));
         
        },
      );
    } else
     // _socket.driverUnsubscribeForWait();

    yield (state as DriverMapLoaded).copyWith(isOnLine: result);
  
  }

  Future<void> _updateMarkers({Marker marker}) async {
    _markers.clear();
    List<Marker> _list = List();
    final _markerIdMyPosition = MarkerId('__myPosition__');
    // if(_iconCar==null)
    final _mMyPosition = Marker(
      markerId: _markerIdMyPosition,
      position: _currentPosition,
      icon: _iconCar,
    );
    _list.add(_mMyPosition);
    if (marker != null) _list.add(marker);
    _markers.addAll(_list);
  }

  Utilisateur get _currentUser => _authentificationBloc.currentUser;
}
