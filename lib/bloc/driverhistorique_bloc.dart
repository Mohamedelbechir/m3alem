import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/course_repository.dart';

part 'driverhistorique_event.dart';
part 'driverhistorique_state.dart';

class DriverhistoriqueBloc
    extends Bloc<DriverhistoriqueEvent, DriverhistoriqueState> {
  final CourseRespository courseRespository;
  final AuthentificationBloc authentificationBloc;

  DriverhistoriqueBloc({
    @required this.courseRespository,
    @required this.authentificationBloc,
  });

  @override
  DriverhistoriqueState get initialState => DriverhistoriqueInitial();

  @override
  Stream<DriverhistoriqueState> mapEventToState(
    DriverhistoriqueEvent event,
  ) async* {
    if (event is DisplayDriverHistoriquePage) {
      yield* _mapDisplayDriverHistoriquePageToState(event);
    }
  }

  Stream<DriverhistoriqueState> _mapDisplayDriverHistoriquePageToState(
      DisplayDriverHistoriquePage event) async* {
    final courses =
        await courseRespository.getDriverCourses(cin: _currentUser.cin);
    yield DriverhistoriqueLoaded(courses: courses);
  }

  Utilisateur get _currentUser => authentificationBloc.currentUser;
}
