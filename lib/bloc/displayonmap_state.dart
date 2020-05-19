part of 'displayonmap_bloc.dart';

abstract class DisplayOnMapState extends Equatable {}

class DisplayOnMapInitial extends DisplayOnMapState {
  @override
  List<Object> get props => [];
}

class MapDisplayed extends DisplayOnMapState {
  final LatLng toLatLng;
  final LatLng fromLatLng;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;

  MapDisplayed({
    this.toLatLng,
    this.fromLatLng,
    this.markers = const {},
    this.polyLines = const {},
  });
}

class MapDisplayingError extends DisplayOnMapState {
  final String message;

  MapDisplayingError(this.message);
  @override
  String toString() => "MapDisplayingError";
}
