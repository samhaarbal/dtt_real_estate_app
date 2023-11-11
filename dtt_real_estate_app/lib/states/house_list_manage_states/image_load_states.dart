import 'dart:io';

abstract class ImageState {
  const ImageState();
}

class ImageInitial extends ImageState {}

class ImageLoadInProgress extends ImageState {}

class ImageLoadSuccess extends ImageState {
  final Map<String, File> loadedImages;

  const ImageLoadSuccess({required this.loadedImages});
}

class ImageLoadFailure extends ImageState {
  final String message;

  const ImageLoadFailure({required this.message});
}