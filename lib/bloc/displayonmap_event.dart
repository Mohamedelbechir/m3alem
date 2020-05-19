part of 'displayonmap_bloc.dart';

abstract class DisplayOnMapEvent extends Equatable {}

class DisplayOnMap extends DisplayOnMapEvent {
  final Course course;

  DisplayOnMap(this.course);
}
