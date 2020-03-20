part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  PhotosEvent();
  List get props => [];
}

class AddPhoto extends PhotosEvent {
  final File file;
  final String codePhoto;

  AddPhoto({@required this.file, @required this.codePhoto});
  @override
  List get props => [this.file];
}

class LoadPhoto extends PhotosEvent {
  final int cin;
  final String codePhoto;

  LoadPhoto({@required this.cin, @required this.codePhoto});
  @override
  List get props => [this.cin, this.codePhoto];
}
class TestHasPhoto extends PhotosEvent {
  final String codePhoto;

  TestHasPhoto({this.codePhoto});
  @override
  List get props => [this.codePhoto];

}