import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:m3alem/widgets/lite_rolling_switch.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/widgets/tag.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DriverMapPage extends StatefulWidget {
  DriverMapPage({Key key}) : super(key: key);

  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    final _bloc = context.bloc<DriverMapBloc>();
    return BlocBuilder<DriverMapBloc, DriverMapState>(
      builder: (context, state) {
        if (state is DriverMapLoaded) {
          List<Widget> _items = state.courses != null
              ? state.courses.map((item) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          '${arrondir(item.prixCourse.toString())} DT - ${arrondir(item.distance.toString())} km',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                        ),
                        subtitle: Text(
                          '>${item.depart} \n>${item.arrivee}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'accepter',
                        color: Colors.blueGrey,
                        icon: Icons.check_box,
                        // onTap: () => _showSnackBar('More'),
                      ),
                      IconSlideAction(
                        caption: 'map',
                        color: Colors.grey[50],
                        icon: Icons.remove_red_eye,
                        // onTap: () => _showSnackBar('Delete'),
                      ),
                    ],
                  );
                }).toList()
              : [];

          _panelHeightClosed = state.courses == null ? 0 : 200.0;
          return SafeArea(
            child: Scaffold(
              body: Stack(alignment: Alignment.topCenter, children: [
                SlidingUpPanel(
                  maxHeight: _panelHeightOpen,
                  minHeight: _panelHeightClosed,
                  parallaxEnabled: true,
                  panelSnapping: false,
                  parallaxOffset: .5,
                  body: GoogleMap(
                    initialCameraPosition:
                        _getCameraPosition(latLng: state.currentLatLng),
                    onMapCreated: _onMapCreated,
                    markers: state.markers,
                    myLocationEnabled: true,
                    polylines: state.polyLines,
                    zoomControlsEnabled: false,
                  ),
                  panelBuilder: (sc) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        controller: sc,
                        children: <Widget>[
                          SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          ..._items,
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState(() {
                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  }),
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

  String arrondir(String valeur) {
    final vls = valeur.split('.');
    final res = vls[0] + "," + vls[1].substring(0, 3);
    return res;
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
