import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dtt_real_estate_app/events/house_fetch_event.dart';
import 'package:dtt_real_estate_app/states/houses_state.dart';
import 'package:dtt_real_estate_app/models/house.dart';

class HouseFetchBloc extends Bloc<HouseEvent, HousesState> {
  HouseFetchBloc() : super(HousesInitial());

  @override
  Stream<HousesState> mapEventToState(HouseEvent event) async* {
    if (event is HouseFetchRequested) {
      yield HousesLoadInProgress();
      try {
        final houses = await _fetchHouses();
        yield HousesLoadSuccess(houses);
      } catch (_) {
        yield HousesLoadFailure();
      }
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
