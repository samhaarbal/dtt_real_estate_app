import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtt_real_estate_app/events/house_list_manage_events/house_list_manage_events.dart';
import 'package:dtt_real_estate_app/states/house_list_manage_states/house_list_manage_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';


/// A Bloc that manages the state of a list of houses, including sorting and searching functionality
class HouseListManageBloc extends Bloc<HouseListManageEvent, HouseListManageState> {
  final List<House> allHouses;

  /// Indicates if the sorting of houses should be in ascending order by default
  static const bool defaultSortAscending = true;


  /// Constructs a [HouseListManageBloc] with an initial sorted state of houses.
  HouseListManageBloc(this.allHouses)
      : super(NoSearchState([])) {
    on<SearchTextChanged>(_onSearchTextChanged);
    on<SortHousesByPriceEvent>(_onSortHousesByPrice);
    on<ClearSearchEvent>(_onClearSearch);

    // Initialize with sorted houses
    _sortHouses(allHouses, defaultSortAscending).then((sortedHouses) {
      emit(NoSearchState(sortedHouses));
    });
  }

  Future<void> _onSearchTextChanged(
      SearchTextChanged event,
      Emitter<HouseListManageState> emit) async {
    // Asynchronous search logic
    final searchText = event.searchText.toLowerCase().replaceAll(' ', '');
    final filteredHouses = await Future(() {
      return allHouses.where((house) =>
      (house.city+house.zip).toLowerCase().replaceAll(' ', '').contains(searchText) ||
          (house.zip+house.city).toLowerCase().replaceAll(' ', '').contains(searchText)
      ).toList();
    });

    // Sorting the results based on the current sort state
    final sortedHouses = await Future(() {
      filteredHouses.sort((a, b) => state.sortAscendingByPrice
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return filteredHouses;
    });

    emit(SearchState(sortedHouses, sortAscendingByPrice: state.sortAscendingByPrice));
  }

  Future<void> _onSortHousesByPrice(
      SortHousesByPriceEvent event,
      Emitter<HouseListManageState> emit) async {
    // Asynchronous sort logic
    final sortedHouses = await Future(() {
      List<House> housesToSort = List.from(state.houses);
      housesToSort.sort((a, b) => event.sortAscending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return housesToSort;
    });

    if (state is SearchState) {
      emit(SearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
    } else {
      emit(NoSearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
    }
  }

  Future<void> _onClearSearch(
      ClearSearchEvent event,
      Emitter<HouseListManageState> emit) async {
    // Resetting the state to NoSearchState with sorted houses
    final sortedHouses = await _sortHouses(allHouses, defaultSortAscending);
    emit(NoSearchState(sortedHouses));
  }

  // Utility function for sorting houses
  Future<List<House>> _sortHouses(List<House> houses, bool ascending) async {
    return [...houses]..sort((a, b) => ascending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
  }
}
