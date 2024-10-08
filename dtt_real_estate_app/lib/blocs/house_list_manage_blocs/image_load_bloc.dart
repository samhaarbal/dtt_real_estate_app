import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dtt_real_estate_app/events/house_list_manage_events/image_load_event.dart';
import 'package:dtt_real_estate_app/states/house_list_manage_states/image_load_states.dart';
import 'package:path/path.dart';


/// A Bloc that handles the loading and caching of images.
class ImageLoadBloc extends Bloc<ImageEvent, ImageState> {
  /// A cache for storing loaded images.
  final Map<String, File> loadedImages = {};

  /// Initializes the ImageLoadbloc with the initial state.
  ImageLoadBloc() : super(ImageInitial()) {
    on<LoadImage>(_onLoadImage);
    on<UpdateLocallyStoredImages>(_onUpdateLocallyStoredImages);
  }

  /// Handles the event of loading an image.
  Future<void> _onLoadImage(LoadImage event, Emitter<ImageState> emit) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File('${directory.path}/${event.filename}');

    // Emit in progress state
    emit(ImageLoadInProgress());

    // Check cache
    if (loadedImages.containsKey(event.filename)) {
      emit(ImageLoadSuccess(loadedImages: loadedImages));
      return;
    }

    // Check local storage
    if (await filePath.exists()) {
      // Cache the image
      loadedImages[event.filename] = filePath;
      emit(ImageLoadSuccess(loadedImages: loadedImages));
      return;
    }

    // Check network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(ImageLoadFailure(message: 'No Internet connection'));
      return;
    }

    // Load from the network
    try {
      final response = await http.get(Uri.parse(event.imageUrl));
      if (response.statusCode == 200) {
        await filePath.writeAsBytes(response.bodyBytes);
        loadedImages[event.filename] = filePath; // Cache the image
        emit(ImageLoadSuccess(loadedImages: loadedImages));
      } else {
        emit(ImageLoadFailure(message: 'Failed to download image'));
      }
    } catch (e) {
      emit(ImageLoadFailure(message: e.toString()));
    }
  }

  // Handler for the remove images from local storage that are no longer online event
  void _onUpdateLocallyStoredImages(UpdateLocallyStoredImages event, Emitter<ImageState> emit) async {
    //Access the application's documents directory.
    final directory = await getApplicationDocumentsDirectory();

    // List all files in the directory synchronously.
    final List<FileSystemEntity> files = directory.listSync();

    // Create a set of valid filenames from the provided event filenames.
    final Set<String> validFilenames = event.filenames.toSet();

    // Iterate through all the FileSystemEntity items.
    for (final file in files) {
      // Check if the item is a file.
      if (file is File) {
        // Extract the filename from the file's full path.
        final fileName = basename(file.path);

        // Check if the filename is not in the valid filenames set, and delete it if so.
        if (!validFilenames.contains(fileName)) {
          await file.delete();
        }
      }
    }
  }
}
