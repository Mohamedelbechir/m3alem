part of 'driver_map_bloc.dart';

abstract class DriverMapState extends Equatable {
  DriverMapState();
}

class DriverMapInitial extends DriverMapState {
  @override
  List<Object> get props => [];
}

class DriverMapLoading extends DriverMapState {}

class DriverMapLoaded extends DriverMapState {
  final LatLng currentLatLng;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final bool isOnLine;

  final List<Course> courses;

  DriverMapLoaded({
    this.currentLatLng,
    this.markers,
    this.polyLines,
    this.isOnLine,
    this.courses,
  });
  @override
  List get props => [
        this.currentLatLng,
        this.markers,
        this.polyLines,
        this.isOnLine,
        this.courses
      ];

  DriverMapLoaded copyWith({
    LatLng currentLatLng,
    Set<Marker> markers,
    Set<Polyline> polyLines,
    bool isOnLine,
    List<Course> courses
  }) {
    return DriverMapLoaded(
      currentLatLng: currentLatLng ?? this.currentLatLng,
      markers: markers ?? this.markers,
      polyLines: polyLines ?? this.polyLines,
      isOnLine: isOnLine ?? this.isOnLine,
      courses: courses ?? this.courses,
    );
  }
}

class DriverMapLoadingFailed extends DriverMapState {}
