// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maps/data/models/place_location.dart';
import 'package:maps/data/models/place_suggestion.dart';
import 'package:maps/data/web_services/place_suggestion_webservices.dart';

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
}
