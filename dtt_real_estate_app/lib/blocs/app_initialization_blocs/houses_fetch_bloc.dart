import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dtt_real_estate_app/events/app_initialization_events/houses_fetch_event.dart';
import 'package:dtt_real_estate_app/states/app_initialization_states/houses_fetch_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';

class HousesFetchBloc extends Bloc<HousesEvent, HousesFetchState> {
  HousesFetchBloc() : super(HousesFetchInitial()) {
    on<HousesFetchRequested>(_onHousesFetchRequested);
  }

  Future<void> _onHousesFetchRequested(
      HousesFetchRequested event,
      Emitter<HousesFetchState> emit,
      ) async {
    emit(HousesFetchInProgress());
    try {
      final houses = await _fetchHouses();
      emit(HousesFetchSuccess(houses));
      print('Houses fetched successfully: ${houses.length}');
    } catch (_) {
      emit(HousesFetchFailure());
    }
  }

  Future<List<House>> _fetchHouses() async {
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
}
