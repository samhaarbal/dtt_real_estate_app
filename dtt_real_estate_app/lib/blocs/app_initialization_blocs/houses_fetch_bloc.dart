import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dtt_real_estate_app/events/app_initialization_events/houses_fetch_event.dart';
import 'package:dtt_real_estate_app/states/app_initialization_states/houses_fetch_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HousesFetchBloc extends Bloc<HousesEvent, HousesFetchState> {
  HousesFetchBloc() : super(HousesFetchInitial()) {
    on<HousesFetchRequested>(_onHousesFetchRequested);
  }

  Future<void> _onHousesFetchRequested(
      HousesFetchRequested event,
      Emitter<HousesFetchState> emit,
      ) async {
    emit(HousesFetchInProgress());
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult != ConnectivityResult.none) {
      try {
        // Internet connection is available, fetch from API
        final houses = await _fetchHousesFromApi();
        // Update local database with fetched houses
        await _saveHousesToLocal(houses);
        emit(HousesFetchSuccess(houses));
        print('Houses fetched successfully: ${houses.length}');
      } catch (e) {
        // If fetching from API fails, attempt to load from local storage
        final localHouses = await _loadHousesFromLocal();
        emit(localHouses.isNotEmpty ? HousesFetchSuccess(localHouses) : HousesFetchFailure());
      }
    } else {
      // No internet connection, load from local storage
      final localHouses = await _loadHousesFromLocal();
      emit(localHouses.isNotEmpty ? HousesFetchSuccess(localHouses) : HousesFetchFailure());
      print(HousesFetchState);
    }
  }

  Future<List<House>> _fetchHousesFromApi() async {
    final response = await http.get(
      Uri.parse('https://intern.d-tt.nl/api/house'),
      headers: {'Access-Key': '98bww4ezuzfePCYFxJEWyszbUXc7dxRx'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((house) => House.fromJson(house)).toList();
    } else {
      throw Exception('Failed to load houses from API');
    }
  }

  Future<void> _saveHousesToLocal(List<House> houses) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the list of houses to a JSON string
    String housesJson = jsonEncode(houses.map((house) => house.toJson()).toList());
    await prefs.setString('cachedHouses', housesJson);
  }

  Future<List<House>> _loadHousesFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? housesJson = prefs.getString('cachedHouses');
    if (housesJson != null) {
      // Decode the JSON string into a list of houses
      List<dynamic> housesList = jsonDecode(housesJson) as List<dynamic>;
      return housesList.map((houseJson) => House.fromJson(houseJson)).toList();
    }
    return [];
  }
}