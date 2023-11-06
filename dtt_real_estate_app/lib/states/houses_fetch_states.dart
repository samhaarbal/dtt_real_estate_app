import 'package:dtt_real_estate_app/models/house.dart';

abstract class HousesState {}

class HousesInitial extends HousesState {}

class HousesLoadInProgress extends HousesState {}

class HousesLoadSuccess extends HousesState {
  final List<House> houses;

  HousesLoadSuccess(this.houses);
}

class HousesLoadFailure extends HousesState {}
