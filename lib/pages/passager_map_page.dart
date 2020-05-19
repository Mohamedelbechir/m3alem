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
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/pages/map_clic.dart';
import 'package:m3alem/widgets/loading_indicator.dart';
import 'package:m3alem/widgets/loading_overlay.dart';
import 'package:m3alem/widgets/notification_card_driver.dart';
import 'package:m3alem/widgets/tag.dart';
import 'package:m3alem/widgets/utilis_buid_widget.dart';

class PassagerMapPage extends StatefulWidget {
  PassagerMapPage({Key key}) : super(key: key);

  @override
  _PassagerMapPageState createState() => _PassagerMapPageState();
}

class _PassagerMapPageState extends State<PassagerMapPage> {
  GoogleMapController _mapController;
  TextEditingController _toLocationController = new TextEditingController();
  TextEditingController _fromLocationController = new TextEditingController();

  PlaceDetail _fromPlaceDetail;
  PlaceDetail _toPlaceDetail;

  @override
  initState() {
    final blocS = context.bloc<SugestionBloc>();
    final blocP = context.bloc<PassagerMapBloc>();

    context.bloc<SugestionBloc>().listen(
      (state) {
        if (state is SugestedDrivers) {
          Future.microtask(
            () async {
              await showModalBottomSheet(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                context: context,
                builder: (context) => BlocProvider<SugestionBloc>.value(
                  value: blocS,
                  child: Container(
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                            child: buildHeaderModal(
                                context: context, title: "Notification")),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                              ),
                              ...state.drivers
                                  .map((item) => CardNotificationDriver(
                                      model: item,
                                      onValid: () {
                                        blocS.add(
                                          SendResquestToDriver(state
                                              .currentCourse
                                              .copyWith(idDriver: item.cin)),
                                        );
                                      }))
                                  .toList(),
                              SizedBox(
                                width: 100,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              context.bloc<SugestionBloc>().add(ResetSugestion());
            },
          );
        } else if (state is SugestionEmpty) {
          Future.microtask(() => Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Aucun chauffeur en ligne'),
                  backgroundColor: Colors.lightBlue,
                ),
              ));
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _blocPassagerMap = context.bloc<PassagerMapBloc>();
    final _blocSugestion = context.bloc<SugestionBloc>();

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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            BlocBuilder<PassagerMapBloc, PassagerMapState>(
              builder: (context, state) {
                if (state is PassagerMapLoaded) {
                  _fromLocationController.text = state.fromTxt;
                  _toLocationController.text = state.toTxt;
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      LoadingOverlay(
                        isLoading: false,
                        child: GoogleMap(
                          initialCameraPosition:
                              _getCameraPosition(latLng: state.from),
                          myLocationEnabled: true,
                          compassEnabled: true,
                          onMapCreated: _onMapCreated,
                          markers: state.markers,
                          polylines: state.polyLines,
                          onLongPress: (latLng) =>
                              _blocPassagerMap.add(LongPress(latLng: latLng)),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Aucun endroit correspondant",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    direction: AxisDirection.up,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _fromLocationController,
                                      decoration: InputDecoration(
                                        labelText: 'Depart',
                                        icon: Icon(Icons.location_on,
                                            color: Colors.black),
                                      ),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, suggestion) {
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
                                      _fromPlaceDetail = await _blocPassagerMap
                                          .getPlaceDetail(suggestion.placeId);
                                      _blocPassagerMap.add(LongPress(
                                        latLng: LatLng(_fromPlaceDetail.lat,
                                            _fromPlaceDetail.lng),
                                        source: MarkerDragSourse.from,
                                      ));
                                    },
                                    suggestionsCallback:
                                        (String pattern) async {
                                      return await _blocPassagerMap
                                          .getSuggestions(pattern);
                                    },
                                  ),
                                  TypeAheadFormField<Place>(
                                    noItemsFoundBuilder: (context) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        "Aucun endroit correspondant",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    direction: AxisDirection.up,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _toLocationController,
                                      decoration: InputDecoration(
                                        labelText: 'Destination',
                                        icon: Icon(Icons.assistant_photo,
                                            color: Colors.black),
                                      ),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, suggestion) {
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
                                      _toPlaceDetail = await _blocPassagerMap
                                          .getPlaceDetail(suggestion.placeId);

                                      _blocPassagerMap.add(LongPress(
                                        latLng: LatLng(_toPlaceDetail.lat,
                                            _toPlaceDetail.lng),
                                        source: MarkerDragSourse.to,
                                      ));

                                      // _moveCamera(_fromPlaceDetail, _toPlaceDetail);
                                    },
                                    suggestionsCallback:
                                        (String pattern) async {
                                      return await context
                                          .bloc<PassagerMapBloc>()
                                          .getSuggestions(pattern);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  state.distance != null
                                      ? Tag(
                                          text:
                                              '${arrondir(state.distance.toString())} km de distance')
                                      : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      color: Colors.black,
                                      onPressed: (_toLocationController
                                                  .text.isEmpty ||
                                              _fromLocationController
                                                  .text.isEmpty)
                                          ? null
                                          : () {
                                              _blocSugestion
                                                  .add(CommanderCourse(
                                                fromLocation: state.from,
                                                toLocation: state.to,
                                                polyLines: state.polyLines,
                                                fromText:
                                                    _fromLocationController
                                                        .text,
                                                toText:
                                                    _toLocationController.text,
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is PassagerMapLoading) {
                  return LoadingIndicator(
                      key: AppM3alemKeys.statsLoadingIndicator);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  String arrondir(String valeur) {
    final vls = valeur.split('.');
    final res = vls[0] + "," + vls[1].substring(0, 2);
    return res;
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
