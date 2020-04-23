import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m3alem/models/freezed_classes.dart';

part 'sugestion_event.dart';
part 'sugestion_state.dart';

class SugestionBloc extends Bloc<SugestionEvent, SugestionState> {
  @override
  SugestionState get initialState => SugestionInitial();

  @override
  Stream<SugestionState> mapEventToState(
    SugestionEvent event,
  ) async* {
    if (event is AddDriverSugestion) {
      yield* _mapAddDriverSugestionToState(event);
    }
  }

  Stream<SugestionState> _mapAddDriverSugestionToState(
      AddDriverSugestion event) async* {
    final drivers = (state is SugestedDrivers)
        ? [...(state as SugestedDrivers).drivers, event.driver]
        : [event.driver];
    yield SugestedDrivers(drivers);
  }
}
