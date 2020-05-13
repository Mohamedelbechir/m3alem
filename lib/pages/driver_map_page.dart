import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/widgets/lite_rolling_switch.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DriverMapPage extends StatefulWidget {
  DriverMapPage({Key key}) : super(key: key);

  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final _bloc = context.bloc<DriverMapBloc>();

    return BlocBuilder<DriverMapBloc, DriverMapState>(
      builder: (context, state) {
        if (state is DriverMapLoaded) {
          return SafeArea(
            child: Scaffold(
              body: Stack(alignment: Alignment.topCenter, children: [
                GoogleMap(
                  initialCameraPosition:
                      _getCameraPosition(latLng: state.currentLatLng),
                  onMapCreated: _onMapCreated,
                  markers: state.markers,
                  myLocationEnabled: true,
                  polylines: state.polyLines,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: LiteRollingSwitch(
                      width: 135,
                      value: state.isOnLine,
                      textOn: ' disponible ',
                      textOff: 'inactive',
                      colorOn: Colors.black,
                      colorOff: Colors.grey,
                      iconOn: Icons.directions_car,
                      iconOff: Icons.power_settings_new,
                      onChanged: (bool etat) {
                        // if (state.isOnLine != etat)
                        _bloc.add(SwichDriverState(isOnLine: etat));
                      },
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
        return Container();
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
    });
  }

  CameraPosition _getCameraPosition({LatLng latLng}) {
    return CameraPosition(
      bearing: 192.8334901395799,
      target: latLng,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    CameraPosition _getCameraPosition({LatLng latLng}) {
      return CameraPosition(
        bearing: 192.8334901395799,
        target: latLng,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
    }

    return BlocBuilder<DriverMapBloc, DriverMapState>(
      builder: (context, state) {
        if (state is DriverMapLoaded) {
          return Scaffold(
            body: GoogleMap(
              initialCameraPosition:
                  _getCameraPosition(latLng: state.currentLatLng),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: state.markers,
              polylines: state.polyLines,
            ),
          );
        } else if (state is DriverMapLoading) {
          return CircularProgressIndicator();
        }
        return Container();
      },
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
