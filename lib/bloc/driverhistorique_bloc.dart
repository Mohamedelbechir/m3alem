import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'driverhistorique_event.dart';
part 'driverhistorique_state.dart';

class DriverhistoriqueBloc extends Bloc<DriverhistoriqueEvent, DriverhistoriqueState> {
  @override
  DriverhistoriqueState get initialState => DriverhistoriqueInitial();

  @override
  Stream<DriverhistoriqueState> mapEventToState(
    DriverhistoriqueEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
