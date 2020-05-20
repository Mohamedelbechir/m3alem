import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/notifdriver_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/phone_service.dart';
import 'package:m3alem/socket/socket_service_driver.dart';

part 'driver_map_event.dart';
part 'driver_map_state.dart';

class DriverMapBloc extends Bloc<DriverMapEvent, DriverMapState> {
  LatLng _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polyline;

  BitmapDescriptor _iconCar;

  final AuthentificationBloc authentificationBloc;
  final NotifDriverBloc notifDriverBloc;

  UtilisateurRepository utilisateurRepository;

  // SocketDriverService socketDriverService;
  SocketServiceDriver socket = SocketServiceDriver();
  DriverMapBloc({
    @required this.utilisateurRepository,
    @required this.authentificationBloc,
    @required this.notifDriverBloc,
  }) {
    _initSocket();
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
    else if (event is DriverConnexionOk)
      print("Connection etablie avec serveur");
    else if (event is DriverConnexionKo)
      print("Connection echouée avec serveur");
    else if (event is DriverWaiting) {
      print("je suis en attente");
    } else if (event is DriverOnLine) {
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
    //if ((state as DriverMapLoaded).isOnLine != event.isOnLine) {
      final result = await utilisateurRepository.setOnline(
        authentificationBloc.currentUser.cin,
        event.isOnLine,
      );
      if (result) {
        authentificationBloc
            .setCurrentUSer(_currentUser.copyWith(isOnLine: event.isOnLine));

        socket.changeDriverStatus(event.isOnLine);

        yield (state as DriverMapLoaded).copyWith(isOnLine: event.isOnLine);
      }
   // }
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

  _initSocket() {
    if (!socket.hastInit)
      socket.initSocket(
        onSuccess: (_, __) {
          add(DriverConnexionOk());
        },
        errorSocket: (_) {
          add(DriverConnexionKo());
        },
      );
  }

  Utilisateur get _currentUser => authentificationBloc.currentUser;
}
