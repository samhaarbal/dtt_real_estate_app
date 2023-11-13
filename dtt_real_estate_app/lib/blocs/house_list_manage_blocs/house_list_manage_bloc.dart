import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtt_real_estate_app/events/house_list_manage_events/house_list_manage_events.dart';
import 'package:dtt_real_estate_app/states/house_list_manage_states/house_list_manage_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';

/// Indicates if the sorting of houses should be in ascending order by default
const bool defaultSortAscending = true;

/// A Bloc that manages the state of a list of houses, including sorting and searching functionality
class HouseListManageBloc extends Bloc<HouseListManageEvent, HouseListManageState> {
  final List<House> allHouses;


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

  /// Handles the event when the user changes the search text, updating the list of houses to show only those that match the search criteria.
  ///
  /// The search is case-insensitive and ignores whitespace.
  Future<void> _onSearchTextChanged(
      SearchTextChanged event,
      Emitter<HouseListManageState> emit) async {
    // Convert search text to lowercase and remove whitespace for a broad match.
    final searchText = event.searchText.toLowerCase().replaceAll(' ', '');

    // Filter the houses based on the search text.
    final filteredHouses = await Future(() {
      return allHouses.where((house) =>
      (house.city + house.zip).toLowerCase().replaceAll(' ', '').contains(searchText) ||
          (house.zip + house.city).toLowerCase().replaceAll(' ', '').contains(searchText)
      ).toList();
    });

    // Sort the filtered houses by price, either in ascending or descending order.
    final sortedHouses = await Future(() {
      filteredHouses.sort((a, b) => state.sortAscendingByPrice
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return filteredHouses;
    });

    // Emit the new state with the sorted, filtered list of houses.
    emit(SearchState(sortedHouses, sortAscendingByPrice: state.sortAscendingByPrice));
  }

  /// Handles the event to sort the list of houses by price.
  ///
  /// The sorting order is determined by the [SortHousesByPriceEvent].
  Future<void> _onSortHousesByPrice(
      SortHousesByPriceEvent event,
      Emitter<HouseListManageState> emit) async {
    // Sort the houses and emit the new state.
    final sortedHouses = await Future(() {
      List<House> housesToSort = List.from(state.houses);
      housesToSort.sort((a, b) => event.sortAscending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return housesToSort;
    });

    // Emit either a SearchState or a NoSearchState based on the current state.
    if (state is SearchState) {
      emit(SearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
    } else {
      emit(NoSearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
    }
  }

  /// Clears the current search and emits the state with all houses, with the same sorting as before searching.
  Future<void> _onClearSearch(
      ClearSearchEvent event,
      Emitter<HouseListManageState> emit) async {
    // Sort the houses in the default sorting order and emit the NoSearchState.
    print(state);
    print(state.sortAscendingByPrice);
    final sortedHouses = await _sortHouses(allHouses, state.sortAscendingByPrice);
    emit(NoSearchState(sortedHouses, sortAscendingByPrice: state.sortAscendingByPrice));
  }

  /// A utility function for asynchronously sorting a list of houses by price.
  ///
  /// It returns a new list of houses sorted in the specified order.
  Future<List<House>> _sortHouses(List<House> houses, bool ascending) async {
    // Create a new list from the original to prevent side effects and sort it.
    return [...houses]..sort((a, b) => ascending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
  }
}
