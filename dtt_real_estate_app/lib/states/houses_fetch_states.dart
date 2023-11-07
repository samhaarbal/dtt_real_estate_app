import 'package:dtt_real_estate_app/models/house.dart';

abstract class HousesFetchState {}

class HousesFetchInitial extends HousesFetchState {}

class HousesFetchInProgress extends HousesFetchState {}

class HousesFetchSuccess extends HousesFetchState {
  final List<House> houses;

  HousesFetchSuccess(this.houses);
}

class HousesFetchFailure extends HousesFetchState {}
