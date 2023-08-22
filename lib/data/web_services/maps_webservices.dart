import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/my_strings.dart';

class PlaceSuggestionWebServices {
  late Dio dio;
  PlaceSuggestionWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getSuggestedPlaces({
    required String place,
    required String sessiontoken,
  }) async {
    try {
      Response response = await dio.get(
        googleMapsPlacesSugg,
        queryParameters: {
          "input": place,
          "type": "address",
          "components": "country:eg",
          "key": googleMapsApiKey,
          "sessiontoken": sessiontoken
        },
      );
      List<dynamic> places = response.data["predictions"];
      print("#### the suggested places are $places");
      return places;
    } catch (error) {
      print('#### the error is $error');
      return [];
    }
  }

  Future<dynamic> getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    try {
      Response response = await dio.get(
        googleMapsPlaceDetails,
        queryParameters: {
          "place_id": placeId,
          "key": googleMapsApiKey,
          "sessiontoken": sessiontoken,
          "fields": "geometry" //to get the longitude and latitude of the place.
        },
      );
      dynamic placeLocation = response.data;
      print("#### the place location is $placeLocation");
      return placeLocation;
    } catch (error) {
      return Future.error("####place location error : $error",
          StackTrace.fromString("####This is the stack trace of the error."));
    }
  }

  //google maps directions
  //origin => Current location
  //destination => The place I want to go to.
  Future<dynamic> getDirection({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      Response response = await dio.get(
        googleMapsDirection,
        queryParameters: {
          "key": googleMapsApiKey,
          "origin": '${origin.latitude},${origin.longitude}',
          "destination": '${destination.latitude},${destination.longitude}'
        },
      );
      dynamic direction = response.data;
      print("#### the direction is $direction");
      return direction;
    } catch (error) {
      return Future.error(
        "#### Direction error : $error",
        StackTrace.fromString("####This is the stack trace of the error."),
      );
    }
  }
}
