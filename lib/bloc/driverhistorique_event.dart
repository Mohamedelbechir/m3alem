part of 'driverhistorique_bloc.dart';

abstract class DriverhistoriqueEvent extends Equatable {
   DriverhistoriqueEvent();
}
class DisplayDriverHistoriquePage extends DriverhistoriqueEvent {
  @override
  String toString() => "DisplayDriverHistoriquePage";
}