import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/socket/socket_service_driver.dart';

part 'notifdriver_event.dart';
part 'notifdriver_state.dart';

class NotifDriverBloc extends Bloc<NotifDriverEvent, NotifDriverState> {
  final SocketServiceDriver _socket = SocketServiceDriver();

  final AuthentificationBloc authentificationBloc;
  NotifDriverBloc({
    @required this.authentificationBloc,
  }) : assert(authentificationBloc != null) {
    /** Ecouter les notifications */

    _socket.listenDriverStatus((onLine) {
      if (onLine) {
        _socket.driverSubscribForWait(
          callback: (course) {
            add(PushNotif(course));
          },
          cin: _currentUser.cin,
        );
      } else {
        _socket.driverUnsubscribeForWait();
      }
    });
  }
  @override
  NotifDriverState get initialState => NotifDriverInitial();

  @override
  Stream<NotifDriverState> mapEventToState(
    NotifDriverEvent event,
  ) async* {
    if (event is ToConsultedNotif) {
      yield* _mapToContultedNotifToState(event);
    } else if (event is PushNotif) {
      yield* _mapPushNotifToState(event);
    } else if (event is AccepterCourse) {
      yield* _mapAccepterCourseToState(event);
    }
  }

  Stream<NotifDriverState> _mapAccepterCourseToState(
      AccepterCourse event) async* {
    final _course = event.course.copyWith(idDriver: _currentUser.cin);
    _socket.acceptCourse(_course);
  }

  Stream<NotifDriverState> _mapPushNotifToState(PushNotif event) async* {
    final _state = state;
    if (_state is NotifLoaded) {
      List<Course> courses = List.from(_state.courses)..add(event.course);
      yield NotifLoaded(courses: courses);
    } else
      yield NotifLoaded(courses: [event.course]);
  }

  Stream<NotifDriverState> _mapToContultedNotifToState(
      ToConsultedNotif event) async* {
    if (state is NotifLoaded) {
      yield (state as NotifLoaded).copyWith(consulted: true);
    } else
      yield NotifLoaded(consulted: true);
  }

  get _currentUser => authentificationBloc.currentUser;
}
