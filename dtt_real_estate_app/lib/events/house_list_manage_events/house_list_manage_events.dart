abstract class HouseListManageEvent {}

class SearchTextChanged extends HouseListManageEvent {
  final String searchText;
  SearchTextChanged(this.searchText);
}

class SortHousesByPriceEvent extends HouseListManageEvent {
  final bool sortAscending;

  SortHousesByPriceEvent(this.sortAscending);
}


class ClearSearchEvent extends HouseListManageEvent {}
