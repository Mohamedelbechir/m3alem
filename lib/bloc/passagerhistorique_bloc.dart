import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'passagerhistorique_event.dart';
part 'passagerhistorique_state.dart';

class PassagerhistoriqueBloc
    extends Bloc<PassagerhistoriqueEvent, PassagerhistoriqueState> {
  @override
  PassagerhistoriqueState get initialState => PassagerhistoriqueInitial();

  @override
  Stream<PassagerhistoriqueState> mapEventToState(
    PassagerhistoriqueEvent event,
  ) async* {
    
  }
}
