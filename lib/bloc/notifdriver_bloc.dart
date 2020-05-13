import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m3alem/models/freezed_classes.dart';

part 'notifdriver_event.dart';
part 'notifdriver_state.dart';

class NotifDriverBloc extends Bloc<NotifDriverEvent, NotifDriverState> {
  @override
  NotifDriverState get initialState => NotifDriverInitial();

  @override
  Stream<NotifDriverState> mapEventToState(
    NotifDriverEvent event,
  ) async* {
    if (event is ToContultedNotif) {
      yield* _mapToContultedNotifToState(event);
    } else if (event is PushNotif) {
      yield* _mapPushNotifToState(event);
      yield (state as NotifLoaded).copyWith(consulted: true);
    }
  }

  Stream<NotifDriverState> _mapPushNotifToState(PushNotif event) async* {
    final _state = state;
    if (_state is NotifLoaded) {
      final courses = List.from(_state.courses)..add(event.course);
      yield NotifLoaded(courses: courses);
    } else
      yield NotifLoaded(courses: [event.course]);
  }

  Stream<NotifDriverState> _mapToContultedNotifToState(
      ToContultedNotif event) async* {
    if (state is NotifLoaded) {
      yield (state as NotifLoaded).copyWith(consulted: true);
    }
  }
}
