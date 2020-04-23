import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/commander_course_bloc.dart';
import 'package:m3alem/modelView/place_model.dart';

class MyTypedTextFieldCommander extends StatefulWidget {
  @override
  _MyTypedTextFieldCommanderState createState() =>
      _MyTypedTextFieldCommanderState();
}

class _MyTypedTextFieldCommanderState extends State<MyTypedTextFieldCommander> {
  TextEditingController _toLocationController = new TextEditingController();
  TextEditingController _fromLocationController = new TextEditingController();

  PlaceDetail _fromPlaceDetail;
  PlaceDetail _toPlaceDetail;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommanderCourseBloc, CommanderCourseState>(
      builder: (context, state) {
        if (state is DisplayedCommander) {
          return Positioned(
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          icon: Icon(Icons.location_on, color: Colors.black),
                        ),
                      ),
                      itemBuilder: (BuildContext context, suggestion) {
                        return ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
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
                        _fromLocationController.text = suggestion.description;
                        _fromPlaceDetail = await context
                            .bloc<CommanderCourseBloc>()
                            .getPlaceDetail(suggestion.placeId);
                        // _moveCamera(_fromPlaceDetail, _toPlaceDetail);
                      },
                      suggestionsCallback: (String pattern) async {
                        return await context
                            .bloc<CommanderCourseBloc>()
                            .getSuggestions(pattern);
                      },
                    ),
                    TypeAheadFormField<Place>(
                      noItemsFoundBuilder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          icon:
                              Icon(Icons.assistant_photo, color: Colors.black),
                        ),
                      ),
                      itemBuilder: (BuildContext context, suggestion) {
                        return ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
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
                        _toLocationController.text = suggestion.description;
                        _toPlaceDetail = await context
                            .bloc<CommanderCourseBloc>()
                            .getPlaceDetail(suggestion.placeId);
                        // _moveCamera(_fromPlaceDetail, _toPlaceDetail);
                      },
                      suggestionsCallback: (String pattern) async {
                        return await context
                            .bloc<CommanderCourseBloc>()
                            .getSuggestions(pattern);
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                )),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
