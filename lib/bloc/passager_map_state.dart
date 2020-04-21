part of 'passager_map_bloc.dart';

abstract class PassagerMapState extends Equatable {
  PassagerMapState();
}

class PassagerMapInitial extends PassagerMapState {
  @override
  List<Object> get props => [];
}

class PassagerMapLoaded extends PassagerMapState {
  final LatLng currentLatLng;
  final LatLng toLatLng;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final String fromTxt;
  final String toTxt;
  final bool isLoading;

  PassagerMapLoaded({
    this.currentLatLng,
    this.markers,
    this.polyLines,
    this.toLatLng,
    this.fromTxt,
    this.toTxt,
    this.isLoading = false,
  });

  @override
  List get props => [
        this.currentLatLng,
        this.markers,
        this.polyLines,
        this.isLoading,
      ];

  PassagerMapLoaded copyWith({
    LatLng currentLatLng,
    Set<Marker> markers,
    Set<Polyline> polyLines,
    bool isLoading,
  }) {
    return PassagerMapLoaded(
      currentLatLng: currentLatLng ?? this.currentLatLng,
      markers: markers ?? this.markers,
      polyLines: polyLines ?? this.polyLines,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'PassagerMapLoaded(currentLatLng: $currentLatLng, markers: $markers, polyLines: $polyLines)';
}

class PassagerMapUpdated extends PassagerMapState {
  final Set<Marker> markers;
  final Set<Polyline> polyLines;

  PassagerMapUpdated({this.markers, this.polyLines});
}

class PassagerMapLoading extends PassagerMapState {
  @override
  String toString() {
    return "PassagerMapLoading";
  }
}
