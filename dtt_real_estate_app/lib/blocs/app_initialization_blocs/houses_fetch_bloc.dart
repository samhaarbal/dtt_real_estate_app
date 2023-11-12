import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dtt_real_estate_app/events/app_initialization_events/houses_fetch_event.dart';
import 'package:dtt_real_estate_app/states/app_initialization_states/houses_fetch_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The URL for the houses API endpoint.
const _housesApiUrl = 'https://intern.d-tt.nl/api/house';

/// The access key for the API.
const _apiAccessKey = '98bww4ezuzfePCYFxJEWyszbUXc7dxRx';

/// The key used for caching houses data in local storage.
const _cachedHousesKey = 'cachedHouses';

/// A Bloc that handles fetching and caching of houses data.
class HousesFetchBloc extends Bloc<HousesEvent, HousesFetchState> {
  /// Initializes the [HousesFetchBloc] with the initial state.
  HousesFetchBloc() : super(HousesFetchInitial()) {
    on<HousesFetchRequested>(_onHousesFetchRequested);
  }

  /// Handler for when houses data is requested.
  Future<void> _onHousesFetchRequested(
      HousesFetchRequested event,
      Emitter<HousesFetchState> emit,
      ) async {
    emit(HousesFetchInProgress());
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final housesFromApi = await _fetchHousesFromApi();
        await _updateLocalCache(housesFromApi);
        emit(HousesFetchSuccess(housesFromApi));
      } catch (_) {
        final localHouses = await _loadHousesFromLocal();
        emit(localHouses.isNotEmpty ? HousesFetchSuccess(localHouses) : HousesFetchFailure());
      }
    } else {
      final localHouses = await _loadHousesFromLocal();
      emit(localHouses.isNotEmpty ? HousesFetchSuccess(localHouses) : HousesFetchFailure());
    }
  }

  /// Fetches houses from the API.
  Future<List<House>> _fetchHousesFromApi() async {
    final response = await http.get(
      Uri.parse(_housesApiUrl),
      headers: {'Access-Key': _apiAccessKey},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((house) => House.fromJson(house)).toList();
    } else {
      throw Exception('Failed to load houses from API');
    }
  }

  /// Saves the list of houses to local storage.
  Future<void> _saveHousesToLocal(List<House> houses) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String housesJson = jsonEncode(houses.map((house) => house.toJson()).toList());
    await prefs.setString(_cachedHousesKey, housesJson);
  }

  /// Loads the list of houses from local storage.
  Future<List<House>> _loadHousesFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? housesJson = prefs.getString(_cachedHousesKey);
    if (housesJson != null) {
      List<dynamic> housesList = jsonDecode(housesJson) as List<dynamic>;
      return housesList.map((houseJson) => House.fromJson(houseJson)).toList();
    }
    return [];
  }

  /// Updates the local cache with the latest houses from the API.
  /// It overwrites the local cache with the fetched list.
  Future<void> _updateLocalCache(List<House> housesFromApi) async {
    await _saveHousesToLocal(housesFromApi);
  }
}
