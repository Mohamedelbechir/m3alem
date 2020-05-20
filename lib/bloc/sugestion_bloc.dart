import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/course_repository.dart';
import 'package:m3alem/socket/socket_service_passager.dart';
import 'package:m3alem/utils/utilis_fonctions.dart';

part 'sugestion_event.dart';
part 'sugestion_state.dart';

class SugestionBloc extends Bloc<SugestionEvent, SugestionState> {
  final GoogleMapServices googleMapServices = GoogleMapServices();
  final SocketServicePassager socket = SocketServicePassager();

  final CourseRespository courseRespository;

  final AuthentificationBloc authentificationBloc;

  SugestionBloc({
    @required this.courseRespository,
    @required this.authentificationBloc,
  });

  @override
  SugestionState get initialState => SugestionInitial();

  @override
  Stream<SugestionState> mapEventToState(
    SugestionEvent event,
  ) async* {
    if (event is CommanderCourse) {
      //le cliquer le button commander
      yield* _mapCommanderCourseToState(event);
    } else if (event is SendResquestToDriver) {
      yield* _mapSendResquestToDriverToState(event);
    } else if (event is ResquestResponse) {
      yield* _mapResquestResponseToState(event);
    } else if (event is ResetSugestion) {
      yield SugestionInitial();
    }
  }

  Stream<SugestionState> _mapResquestResponseToState(
      ResquestResponse event) async* {
    yield RespondedRequest(event.course, event.confirmed);
  }

  Stream<SugestionState> _mapSendResquestToDriverToState(
      SendResquestToDriver event) async* {
    socket.passagerSendRequest(
      course: event.course,
      callback: (course, confirmed) {
        add(ResquestResponse(confirmed: confirmed, course: course));
      },
    );
  }

  Stream<SugestionState> _mapCommanderCourseToState(
      CommanderCourse event) async* {
    double distance = calculDistanceCourse(event.polyLines.first.points);
    final prix = await courseRespository.getPrixCourse(distance);

    final _course = Course(
      latLngDepart: latLngToString(event.fromLocation),
      latLngArrivee: latLngToString(event.toLocation),
      depart: event.fromText,
      arrivee: event.toText,
      dateCourse: DateTime.now(),
      distance: distance,
      prixCourse: prix,
      idPassager: _currentUser.cin,
    );
    final drivers = await courseRespository.getOnLineDriverForCourse();

    if (drivers.isEmpty)
      yield SugestionEmpty();
    else
      yield SugestedDrivers(drivers: drivers, currentCourse: _course);
    // sugestionBloc.add(AddDriverSugestion(drivers: drivers, course: _course));
  }

  Utilisateur get _currentUser => authentificationBloc.currentUser;
}
