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

class PhotoAdded extends PhotosState {
  final String message;

  PhotoAdded({this.message});
  @override
  List get props => [this.message];
}

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
  @override
  String toString() => 'PhotoNotAdded';
}

class PhotoHasUploaded extends PhotosState {
  final File file;
  final Uint8List fileUint8List;

  PhotoHasUploaded({this.file, this.fileUint8List});
  @override
  List get props => [this.file];
  @override
  String toString() => "PhotoHasUploaded";
}

class PhotoHasNotUploaded extends PhotosState {
  @override
  String toString() => 'PhotoHasNotUploaded';
}
