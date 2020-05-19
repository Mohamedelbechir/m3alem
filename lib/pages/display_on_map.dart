import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/displayonmap_bloc.dart';
import 'package:m3alem/utils/utilis_fonctions.dart';

import '../m3alem_keys.dart';

class 
DiplayOnMap extends StatefulWidget {
  @override
  _DiplayOnMapState createState() => _DiplayOnMapState();
}

class _DiplayOnMapState extends State<DiplayOnMap> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text("Map - visualisation"),
            centerTitle: true,
          ),
          body: BlocBuilder<DisplayOnMapBloc, DisplayOnMapState>(
              builder: (context, state) {
            if (state is MapDisplayed) {
              return GoogleMap(
                key: AppM3alemKeys.googleMap,
                initialCameraPosition:
                    getCameraPosition(latLng: state.fromLatLng),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: state.markers,
                myLocationEnabled: true,
                polylines: state.polyLines,
                zoomControlsEnabled: false,
              );
            } else if (state is MapDisplayingError) {
              return Center(
                child: Text(state.message),
              );
            }
            return CircularProgressIndicator();
          })),
    );
  }
}
