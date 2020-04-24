import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/modelView/place_model.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/course_repository.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/socket/socket_service_passager.dart';

part 'commander_course_event.dart';
part 'commander_course_state.dart';

class CommanderCourseBloc
    extends Bloc<CommanderCourseEvent, CommanderCourseState> {
  final AuthentificationBloc _authentificationBloc;
  final PassagerMapBloc _passagerMapBloc;
  final SugestionBloc _sugestionBloc;
  final SocketServicePassager _socket;
  Course _course;

  final CourseRespository _courseRespository;

  final UtilisateurRepository _utilisateurRepository;

  final GoogleMapServices _googleMapServices;

  CommanderCourseBloc({
    @required AuthentificationBloc authentificationBloc,
    @required PassagerMapBloc passagerMapBloc,
    @required CourseRespository courseRespository,
    @required SocketServicePassager socket,
    @required GoogleMapServices googleMapServices,
    @required SugestionBloc sugestionBloc,
    @required UtilisateurRepository utilisateurRepository,
  })  : _authentificationBloc = authentificationBloc,
        _passagerMapBloc = passagerMapBloc,
        _sugestionBloc = sugestionBloc,
        _courseRespository = courseRespository,
        _utilisateurRepository = utilisateurRepository,
        _googleMapServices = googleMapServices,
        _socket = socket;

  @override
  CommanderCourseState get initialState => CommanderCourseInitial();

  @override
  Stream<CommanderCourseState> mapEventToState(
    CommanderCourseEvent event,
  ) async* {
    if (event is CommanderCourse) {
      yield* _mapCommanderCourseToState(event);
    } else if (event is DisplayCommandeCourse) {
      yield* _mapDisplayCommandeCourseToState(event);
    } else if (event is UpdateFromMap) {
      yield* _mapUpdateFromMapToState(event);
    } else if (event is SelectDriver) {
      yield* _mapSelectDriverToState(event);
    }
  }

  Stream<CommanderCourseState> _mapUpdateFromMapToState(
      UpdateFromMap event) async* {
    yield CommanderCourseDisplayed(
      from: event.from,
      to: event.to,
      fromText: event.fromText,
      toText: event.toText,
    );
  }

  Stream<CommanderCourseState> _mapDisplayCommandeCourseToState(
      DisplayCommandeCourse event) async* {
    yield CommanderCourseDisplayed();
  }

  Stream<CommanderCourseState> _mapSelectDriverToState(
      SelectDriver event) async* {}

  Stream<CommanderCourseState> _mapCommanderCourseToState(
      CommanderCourse event) async* {
    var randomizer = Random();
    double distance = randomizer.nextInt(10).toDouble();
    final prix = await _courseRespository.getPrixCourse(distance);
    if (_course == null)
      _course = Course(
        depart: event.fromText,
        arrivee: event.toText,
        dateCourse: DateTime.now(),
        distance: distance,
        prixCourse: prix,
        idPassager: _currentUser.cin,
      );

    _socket.passagerSendRequest(
      course: _course,
      callback: (Course course) async {
        final driver = await _utilisateurRepository.getByCin(course.idDriver);
        _sugestionBloc.add(AddDriverSugestion(driver));
      },
    );
  }

  Future<List<Place>> getSuggestions(String pattern) async {
    return await _googleMapServices.getSuggestions(pattern);
  }

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    return await _googleMapServices.getPlaceDetail(placeId);
  }

  Utilisateur get _currentUser => _authentificationBloc.currentUser;
  LatLng get currentPosition => _passagerMapBloc.currentPosition;
}
