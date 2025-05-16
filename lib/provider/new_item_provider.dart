import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewItemNotifier extends StateNotifier<List<Place>> {
  NewItemNotifier() : super([]);

  void addFavouritePalce(Place place) {
    state = [...state, place];
  }
}

final favouriteProvider = StateNotifierProvider<NewItemNotifier, List<Place>>(
  (ref) => NewItemNotifier(),
);
