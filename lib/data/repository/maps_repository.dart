// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/data/models/place_direction.dart';
import 'package:maps/data/models/place_location.dart';
import 'package:maps/data/models/place_suggestion.dart';
import 'package:maps/data/web_services/maps_webservices.dart';

class SuggestionsRepository {
  late PlaceSuggestionWebServices suggestionsWebService;
  SuggestionsRepository({
    required this.suggestionsWebService,
  });

  Future<List<PlaceSuggestion>> getSuggestedPlaces({
    required String place,
    required String sessiontoken,
  }) async {
    final places = await suggestionsWebService.getSuggestedPlaces(
        place: place, sessiontoken: sessiontoken);

    return places.map((place) => PlaceSuggestion.fromJson(place)).toList();
  }

  Future<PlaceLocation> getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    final placeLocation = await suggestionsWebService.getPlaceLocation(
      placeId: placeId,
      sessiontoken: sessiontoken,
    );

    return PlaceLocation.fromJson(placeLocation);
  }

  Future<PlaceDirection> getDirection({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final directions = await suggestionsWebService.getDirection(
      origin: origin,
      destination: destination,
    );
    return PlaceDirection.fromJson(directions);
  }
}
