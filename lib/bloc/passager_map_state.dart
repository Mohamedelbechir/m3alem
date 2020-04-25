part of 'passager_map_bloc.dart';

abstract class PassagerMapState extends Equatable {
  PassagerMapState();
}

class PassagerMapInitial extends PassagerMapState {
  @override
  List<Object> get props => [];
}

class PassagerMapLoaded extends PassagerMapState {
  final LatLng from;
  final LatLng to;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final String fromTxt;
  final String toTxt;
  final bool isLoading;
  final double distance;

  PassagerMapLoaded({
    this.from,
    this.markers,
    this.polyLines,
    this.to,
    this.fromTxt,
    this.toTxt,
    this.isLoading = false,
    this.distance,
  });

  @override
  List get props => [
        this.from,
        this.markers,
        this.polyLines,
        this.to,
        this.fromTxt,
        this.toTxt,
        this.isLoading,
        this.distance,
      ];

  PassagerMapLoaded copyWith({
    LatLng from,
    LatLng toLatLng,
    Set<Marker> markers,
    Set<Polyline> polyLines,
    String fromTxt,
    String toTxt,
    bool isLoading,
    double distance,
  }) {
    return PassagerMapLoaded(
      from: from ?? this.from,
      to: toLatLng ?? this.to,
      markers: markers ?? this.markers,
      polyLines: polyLines ?? this.polyLines,
      fromTxt: fromTxt ?? this.fromTxt,
      toTxt: toTxt ?? this.toTxt,
      isLoading: isLoading ?? this.isLoading,
      distance: distance ?? this.distance,
    );
  }

  @override
  String toString() {
    return 'PassagerMapLoaded(from: $from, toLatLng: $to, markers: $markers, polyLines: $polyLines, fromTxt: $fromTxt, toTxt: $toTxt, isLoading: $isLoading, distance: $distance)';
  }
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
