import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:m3alem/bloc/commander_course_bloc.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/pages/map_clic.dart';
import 'package:m3alem/widgets/loading_indicator.dart';
import 'package:m3alem/widgets/loading_overlay.dart';
import 'package:m3alem/widgets/typed_textfield_commande_course.dart';

class PassagerMapPage extends StatefulWidget {
  PassagerMapPage({Key key}) : super(key: key);

  @override
  _PassagerMapPageState createState() => _PassagerMapPageState();
}

class _PassagerMapPageState extends State<PassagerMapPage> {
  final MarkerId _myLocationMarkeId = MarkerId("__myLocation__");
  Set<Marker> _markers = {};
  BitmapDescriptor _myLocationIcon;

  LatLng _selectedPosition;
  LatLng _currentLatLng;
  CameraPosition _kCurrent;
  GoogleMapController _mapController;

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Marker currentPositionMarker;

  Future<Marker> _getCurrentPositionMarker(context, {LatLng latLng}) async {
    MarkerId markerId = MarkerId("currentPosition");
    BitmapDescriptor icon = await _getCurrentLocationIcon(context);
    Marker marker = Marker(
      markerId: markerId,
      position: _currentLatLng,
      infoWindow: InfoWindow(title: "Depart", snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
      icon: icon,
    );
    // marker.copyWith(positionParam: )c
    return marker;
  }

  void _onMarkerDragEnd(markerId, position) {}
  void _onMarkerTapped(markerId) {}

  Future<BitmapDescriptor> _getCurrentLocationIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    const AssetImage('assets/img/mylocation.png')
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }

  @override
  initState() {
    super.initState();
    _currentLatLng = LatLng(37.42796133580664, -122.085749655962);
    _kCurrent = CameraPosition(target: _currentLatLng, zoom: 14.4746);
    _markers.add(Marker(
      markerId: _myLocationMarkeId,
      infoWindow: InfoWindow(
        title: "Position actuelle",
      ),
      onTap: () {},
    ));
    /* BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio:2.5 ,size: Size(5, 5)),
            'assets/img/mylocation.png')
        .then((onValue) {
      //_myLocationIcon = onValue;
      setState(() {
        _markers.add(Marker(
          markerId: _myLocationMarkeId,
          //position: LatLng(myLocation.latitude, myLocation.longitude),
          icon: onValue,
          infoWindow: InfoWindow(
            title: "Ma position",
          ),
          onTap: () {},
        ));
      });
    });*/

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPositionMarker(context).then((value) {
        setState(() {
          currentPositionMarker = value;
        });
      });
    }); */

    /*  BitmapDescriptor icon;
    _getCurrentLocationIcon(context).then((value) {
      setState(() {
        icon = value;
        currentPositionMarker = currentPositionMarker.copyWith(iconParam: icon);
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _getCameraPosition(
        {LatLng latLng =
            const LatLng(37.43296265331129, -122.08832357078792)}) {
      return CameraPosition(
        bearing: 192.8334901395799,
        target: latLng,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
    }

    //final _bloc = context.bloc<PassagerMapBloc>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LoadingOverlay(
              isLoading: false,
              child: BlocBuilder<PassagerMapBloc, PassagerMapState>(
                builder: (context, state) {
                  if (state is PassagerMapLoaded && _markers.isNotEmpty) {
                    return GoogleMap(
                      initialCameraPosition:
                          _getCameraPosition(latLng: state.currentLatLng),
                      myLocationEnabled: true,
                      compassEnabled: true,
                      onMapCreated: _onMapCreated,
                      markers: state.markers,
                      polylines: state.polyLines,
                      onLongPress: _onLongPress,
                    );
                  }
                  if (state is PassagerMapLoading) {
                    return LoadingIndicator(
                        key: AppM3alemKeys.statsLoadingIndicator);
                  }
                  return Container();
                },
              ),
            ),
            MyTypedTextFieldCommander(),
            BlocBuilder<SugestionBloc, SugestionState>(
              builder: (context, state) {
                if (state is SugestedDrivers) {
                  return Positioned(
                    bottom: 5,
                    right: 0,
                    left: 0,
                    child: Card(
                      child: ListView.separated(
                        itemBuilder: (_, index) => ListTile(
                          title: Text(state.drivers[index].cin.toString()),
                          onTap: () => context
                              .bloc<CommanderCourseBloc>()
                              .add(SelectDriver(state.drivers[index])),
                        ),
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey[50]),
                        itemCount: state.drivers.length,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLongPress(LatLng latLng) {
    this._selectedPosition = latLng;
    context.bloc<PassagerMapBloc>().add(LongPress(latLng: latLng));
  }

  void _onTap(LatLng latLng) {
    print(latLng);
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
    });
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
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
