abstract class ImageEvent {
  const ImageEvent();
}

class LoadImage extends ImageEvent {
  final String imageUrl;
  final String filename;

  LoadImage(this.imageUrl, this.filename);
}