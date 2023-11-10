import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dtt_real_estate_app/events/house_list_manage_events/image_load_event.dart';
import 'package:dtt_real_estate_app/states/house_list_manage_states/image_load_states.dart';

class ImageLoadBloc extends Bloc<ImageEvent, ImageState> {

  ImageLoadBloc() : super(ImageInitial()) {
    on<LoadImage>(_onLoadImage);
  }

  Future<void> _onLoadImage(LoadImage event, Emitter<ImageState> emit) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File('${directory.path}/${event.filename}');

    if (await filePath.exists()) {
      emit(ImageLoadSuccess(image: filePath));
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(ImageLoadFailure(message: 'No Internet connection'));
        return;
      }

      try {
        final response = await http.get(Uri.parse(event.imageUrl));
        if (response.statusCode == 200) {
          await filePath.writeAsBytes(response.bodyBytes);
          emit(ImageLoadSuccess(image: filePath));
        } else {
          emit(ImageLoadFailure(message: 'Failed to download image'));
        }
      } catch (e) {
        emit(ImageLoadFailure(message: e.toString()));
      }
    }
  }
}
