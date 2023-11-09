import 'package:dtt_real_estate_app/models/house.dart';

abstract class HouseListManageState {
  final List<House> houses;
  final bool sortAscendingByPrice;

  HouseListManageState(this.houses, {this.sortAscendingByPrice = true});
}

class NoSearchState extends HouseListManageState {
  NoSearchState(List<House> allHouses, {bool sortAscendingByPrice = true}) : super(allHouses, sortAscendingByPrice: sortAscendingByPrice);
}

class SearchState extends HouseListManageState {
  SearchState(List<House> filteredHouses, {bool sortAscendingByPrice = true}) : super(filteredHouses, sortAscendingByPrice: sortAscendingByPrice);
}


