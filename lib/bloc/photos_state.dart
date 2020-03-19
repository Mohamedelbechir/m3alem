part of 'photos_bloc.dart';

abstract class PhotosState extends Equatable {
  PhotosState();

  @override
  List get props => [];
}

class PhotosInitial extends PhotosState {
  PhotosInitial();
  @override
  String toString() => "PhotosInitial";
}

class PhotoAdded extends PhotosState {}

class PhotoLoaded extends PhotosState {
  final File file;

  PhotoLoaded({this.file});
  @override
  List get props => [this.file];
}

class PhotoNotAdded extends PhotosState {
  final String message;

  PhotoNotAdded({@required this.message});
  @override
  List get props => [this.message];
}
