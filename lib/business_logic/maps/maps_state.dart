part of 'maps_cubit.dart';

class MapsState {}

class SuggestionsInitial extends MapsState {}

class SuggestionsLoaded extends MapsState {
  final dynamic places;
  SuggestionsLoaded({required this.places});
}

class PlaceLocationLoaded extends MapsState {
  final PlaceLocation placeLocation;
  PlaceLocationLoaded({required this.placeLocation});
}

class PlaceDirectionLoaded extends MapsState {
  final PlaceDirection placeDirection;
  PlaceDirectionLoaded({required this.placeDirection});
}
