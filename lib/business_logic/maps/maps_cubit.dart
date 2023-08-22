import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/data/models/place_direction.dart';

import '../../data/models/place_location.dart';
import '../../data/models/place_suggestion.dart';
import '../../data/repository/maps_repository.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  SuggestionsRepository repository;
  MapsCubit({required this.repository}) : super(SuggestionsInitial());
  List<PlaceSuggestion>? places;
  void getSuggestedPlaces({
    required String place,
    required String sessiontoken,
  }) async {
    places = await repository.getSuggestedPlaces(
        place: place, sessiontoken: sessiontoken);
    emit(SuggestionsLoaded(places: places));
  }

  void getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    repository
        .getPlaceLocation(
      placeId: placeId,
      sessiontoken: sessiontoken,
    )
        .then((value) {
      emit(PlaceLocationLoaded(placeLocation: value));
    });
  }

  void getPlaceDirection({
    required LatLng origin,
    required LatLng destinaton,
  }) async {
    repository
        .getDirection(
      origin: origin,
      destination: destinaton,
    )
        .then((value) {
      emit(PlaceDirectionLoaded(placeDirection: value));
    });
  }
}
