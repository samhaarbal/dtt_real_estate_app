abstract class ImageEvent {
  const ImageEvent();
}

class LoadImage extends ImageEvent {
  final String imageUrl;
  final String filename;

  const LoadImage({required this.imageUrl, required this.filename});
}