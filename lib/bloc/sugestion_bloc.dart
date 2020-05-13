import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m3alem/models/freezed_classes.dart';

part 'sugestion_event.dart';
part 'sugestion_state.dart';

class SugestionBloc extends Bloc<SugestionEvent, SugestionState> {
  Course _currentCourse;

  @override
  SugestionState get initialState => SugestionInitial();
  Course get currentCourse => _currentCourse;

  @override
  Stream<SugestionState> mapEventToState(
    SugestionEvent event,
  ) async* {
    if (event is AddDriverSugestion) {
      yield* _mapAddDriverSugestionToState(event);
    } else if (event is ResetSugestion) yield SugestionInitial();
  }

  Stream<SugestionState> _mapAddDriverSugestionToState(
      AddDriverSugestion event) async* {
    _currentCourse = event.course;
    if (event.drivers.isEmpty)
      yield SugestionEmpty();
    else
      yield SugestedDrivers(drivers: event.drivers);
  }
}
