abstract class ImageEvent {
  const ImageEvent();
}

class LoadImage extends ImageEvent {
  final String imageUrl;
  final String filename;

  LoadImage(this.imageUrl, this.filename);
}

// The event class for updating locally stored images
class UpdateLocallyStoredImages extends ImageEvent {
  final List<String> filenames;

  UpdateLocallyStoredImages(this.filenames);
}
