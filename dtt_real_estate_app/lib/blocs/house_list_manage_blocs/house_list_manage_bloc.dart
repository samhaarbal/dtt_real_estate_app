import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtt_real_estate_app/events/house_list_manage_events/house_list_manage_events.dart';
import 'package:dtt_real_estate_app/states/house_list_manage_states/house_list_manage_states.dart';
import 'package:dtt_real_estate_app/models/house.dart';

class HouseListManageBloc extends Bloc<HouseListManageEvent, HouseListManageState> {
  final List<House> allHouses;

  HouseListManageBloc(this.allHouses) : super(NoSearchState(allHouses..sort((a, b) => a.price.compareTo(b.price)))) {
    on<SearchTextChanged>(_onSearchTextChanged);
    on<SortHousesByPriceEvent>(_onSortHousesByPrice);
    on<ClearSearchEvent>(_onClearSearch);
  }

    // Handle search text change event
  void _onSearchTextChanged(
      SearchTextChanged event,
      Emitter<HouseListManageState> emit) {
    final searchText = event.searchText.replaceAll(' ', '').toLowerCase();

    List<House> cityOrZipMatched = allHouses.where((house) =>
    house.city.toLowerCase().replaceAll(' ', '').contains(searchText) ||
        house.zip.toLowerCase().replaceAll(' ', '').contains(searchText)).toList();

    List<House> bothMatched = allHouses.where((house) =>
    (house.city.toLowerCase().replaceAll(' ', '') + house.zip.toLowerCase().replaceAll(' ', '')).contains(searchText) ||
        (house.zip.toLowerCase().replaceAll(' ', '') + house.city.toLowerCase().replaceAll(' ', '')).contains(searchText)).toList() ;

    List<House> filteredHouses;

    if (bothMatched.isNotEmpty) {
      // If there are houses that match both city and zip, prioritize them.
      filteredHouses = bothMatched;
    } else if (bothMatched.isEmpty && cityOrZipMatched.isNotEmpty) {
      // If no houses match both, show houses that match either city or zip.
      filteredHouses = cityOrZipMatched;
    } else {
      filteredHouses = [];
    }

    if (state.sortAscendingByPrice) {
      filteredHouses.sort((a, b) => a.price.compareTo(b.price));
      emit(SearchState(filteredHouses, sortAscendingByPrice: state.sortAscendingByPrice));
    } else {
      // Assuming that false means sorting in descending order.
      filteredHouses.sort((a, b) => b.price.compareTo(a.price));
      emit(SearchState(filteredHouses, sortAscendingByPrice: state.sortAscendingByPrice));
    }
  }

  void _onSortHousesByPrice(
      SortHousesByPriceEvent event,
      Emitter<HouseListManageState> emit) {
    // Check if the current state is SearchState
    if (state is SearchState) {
      List<House> sortedHouses = List<House>.from(state.houses);

      // Apply the sorting based on the event's sortAscending value
      if (event.sortAscending) {
        sortedHouses.sort((a, b) => a.price.compareTo(b.price));
        emit(SearchState(
            sortedHouses, sortAscendingByPrice: event.sortAscending));
      } else {
        sortedHouses.sort((a, b) => b.price.compareTo(a.price));
        emit(SearchState(
            sortedHouses, sortAscendingByPrice: event.sortAscending));
      }
    }
    else if (state is NoSearchState) {
      List<House> sortedHouses = List<House>.from(state.houses);

      // Apply the sorting based on the event's sortAscending value
      if (event.sortAscending) {
        sortedHouses.sort((a, b) => a.price.compareTo(b.price));
        emit(NoSearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
      } else {
        sortedHouses.sort((a, b) => b.price.compareTo(a.price));
        emit(NoSearchState(sortedHouses, sortAscendingByPrice: event.sortAscending));
      }
    }
  }


  void _onClearSearch(
      ClearSearchEvent event,
      Emitter<HouseListManageState> emit,
      ) {

    if (state.sortAscendingByPrice) {
      allHouses.sort((a, b) => a.price.compareTo(b.price));
      emit(NoSearchState(allHouses, sortAscendingByPrice: state.sortAscendingByPrice));
    } else {
      // Assuming that false means sorting in descending order.
      allHouses.sort((a, b) => b.price.compareTo(a.price));
      emit(NoSearchState(allHouses, sortAscendingByPrice: state.sortAscendingByPrice));
    }
  }
// Add other event handlers using on<Event> here if needed
}

