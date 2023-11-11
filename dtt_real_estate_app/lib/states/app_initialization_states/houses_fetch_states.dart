import 'package:dtt_real_estate_app/models/house.dart';

abstract class HousesFetchState {
  final List<House> houses;

  HousesFetchState({List<House>? houses}) : this.houses = houses ?? [];
}

class HousesFetchInitial extends HousesFetchState {}

class HousesFetchInProgress extends HousesFetchState {}

class HousesFetchSuccess extends HousesFetchState {
  final List<House> houses;

  HousesFetchSuccess(this.houses) : super(houses: houses);
}

class HousesFetchFailure extends HousesFetchState {}

