import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/pages/map_clic.dart';
import 'package:m3alem/widgets/loading_indicator.dart';
import 'package:m3alem/widgets/loading_overlay.dart';

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

  TextEditingController _toLocationController = new TextEditingController();
  TextEditingController _fromLocationController = new TextEditingController();

  PlaceDetail _fromPlaceDetail;
  PlaceDetail _toPlaceDetail;

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

    final _bloc = context.bloc<PassagerMapBloc>();
    return BlocBuilder<PassagerMapBloc, PassagerMapState>(
      builder: (context, state) {
        if (state is PassagerMapLoaded && _markers.isNotEmpty) {
          /* final location = _markers
              .firstWhere((marker) => marker.markerId == _myLocationMarkeId);
          _markers.removeWhere((marker) => marker == location);
          _markers.add(location.copyWith(positionParam: state.currentLatLng));
*/
          return SafeArea(
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  LoadingOverlay(
                    isLoading: state.isLoading,
                    child: GoogleMap(
                      initialCameraPosition:
                          _getCameraPosition(latLng: state.currentLatLng),
                      myLocationEnabled: true,
                      compassEnabled: true,
                      onMapCreated: _onMapCreated,
                      markers: state.markers,
                      polylines: state.polyLines,
                      onLongPress: _onLongPress,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    right: 5,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child: Column(
                          children: <Widget>[
                            TypeAheadField<Place>(
                              noItemsFoundBuilder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Aucun endroit correspondant",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 18.0),
                                ),
                              ),
                              direction: AxisDirection.up,
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _fromLocationController,
                                decoration: InputDecoration(
                                  labelText: 'Depart',
                                  icon: Icon(Icons.location_on,
                                      color: Colors.black),
                                ),
                              ),
                              itemBuilder: (BuildContext context, suggestion) {
                                return ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    suggestion.description,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                _fromLocationController.text =
                                    suggestion.description;
                                _fromPlaceDetail = await _bloc.getPlaceDetail(
                                  suggestion.placeId,
                                );
                                // _moveCamera(_fromPlaceDetail, _toPlaceDetail);
                              },
                              suggestionsCallback: (String pattern) async {
                                return await _bloc.getSuggestions(pattern);
                              },
                            ),
                            TypeAheadFormField<Place>(
                              noItemsFoundBuilder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Aucun endroit correspondant",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 18.0),
                                ),
                              ),
                              direction: AxisDirection.up,
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _fromLocationController,
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  icon: Icon(Icons.assistant_photo,
                                      color: Colors.black),
                                ),
                              ),
                              itemBuilder: (BuildContext context, suggestion) {
                                return ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    suggestion.description,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                _toLocationController.text =
                                    suggestion.description;
                                _toPlaceDetail = await _bloc.getPlaceDetail(
                                  suggestion.placeId,
                                );
                                // _moveCamera(_fromPlaceDetail, _toPlaceDetail);
                              },
                              suggestionsCallback: (String pattern) async {
                                return await _bloc.getSuggestions(pattern);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black,
                                onPressed: () {
                                  _bloc.add(CommanderCourse(
                                    fromLocation: state.currentLatLng,
                                    toLocation: LatLng(
                                      _toPlaceDetail.lat,
                                      _toPlaceDetail.lng,
                                    ),
                                    fromText: _fromLocationController.text,
                                    toText: _toLocationController.text,
                                  ));
                                },
                                child: Text(
                                  'Commander',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        if (state is PassagerMapLoading) {
          return LoadingIndicator(key: AppM3alemKeys.statsLoadingIndicator);
        }
        return Container();
      },
    );
  }

/*  void _moveCamera(
      PlaceDetail _fromplaceDetail, PlaceDetail _toPlaceDetail) async {
    if (_markers.length > 0) {
      setState(() {
        _markers.clear();
      });
    }
    if (_toLocationController.text != null && _toPlaceDetail != null) {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_toPlaceDetail.lat, _toPlaceDetail.lng),
      ));
    }

    setState(() {
      if (_fromLocationController.text != null && _fromplaceDetail != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(_fromplaceDetail.placeId),
            position: LatLng(_fromplaceDetail.lat, _fromplaceDetail.lng),
            icon: _mylocation,
            infoWindow: InfoWindow(
              title: "pick up",
              snippet: _fromplaceDetail.formattedAddress,
            ),
          ),
        );
      }

      if (_toLocationController.text != null && _toPlaceDetail != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(_toPlaceDetail.placeId),
            position: LatLng(_toPlaceDetail.lat, _toPlaceDetail.lng),
            infoWindow: InfoWindow(
              title: "destination",
              snippet: _toPlaceDetail.formattedAddress,
            ),
          ),
        );
      }
    });

    if (_toLocationController.text != null &&
        _toPlaceDetail != null &&
        _fromLocationController.text != null &&
        _fromplaceDetail != null) {
      await setPolylines();
    }
  }

  */
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

  _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();

    _setCurrentLocation(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    location.onLocationChanged.listen((LocationData currentLocation) {
      _setCurrentLocation(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      );
    });
  }

  _setCurrentLocation({double latitude, double longitude}) {
    print(latitude);
    setState(() {
      _currentLatLng = LatLng(latitude, longitude);
      _kCurrent = CameraPosition(target: _currentLatLng, zoom: 14.4746);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
