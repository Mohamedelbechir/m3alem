class ModelItemListTilePhoto {
  final String codePhoto;
  final String title;
  final String itemAddPhotoDocTitle;
  final String itemAddPhotoDocContent;
  bool hasUploaded;

  ModelItemListTilePhoto({
    this.codePhoto,
    this.title,
    this.itemAddPhotoDocTitle,
    this.itemAddPhotoDocContent,
    this.hasUploaded = false,
  });
}
