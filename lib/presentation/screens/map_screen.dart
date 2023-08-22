import 'dart:async';
import 'package:maps/data/models/place_direction.dart';
import 'package:maps/presentation/widgets/distance_and_time.dart';

import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../business_logic/maps/maps_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/place_suggestion.dart';
import '../../helpers/location_helper.dart';
import '../widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/place_location.dart';
import '../widgets/custom_places_list_item.dart';
import '../widgets/custom_progress_indicator.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var controller = FloatingSearchBarController();
  List<PlaceSuggestion> places = [];
  String? phoneNumber;
  var cubit = PhoneAuthCubit();
  static Position? position;
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    bearing: 0.0,
    zoom: 13,
  );
  final Completer<GoogleMapController> _mapController = Completer();
  //These variables for getting the clicked place location.
  Set<Marker> markers = {};
  late PlaceSuggestion placeSuggestion;
  late PlaceLocation selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition newCameraPosition;
  //These variables for getting the clicked place direction.
  PlaceDirection? placeDirection;
  var progressndicator = false;
  List<LatLng> polylinePoints = [];
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    await LocationHelper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null ? _buildGoogleMap() : const CustomProgrssIndicator(),
          _buildSearchBar(),
          isSearchedPlaceMarkerClicked == true
              ? DistanceAndTime(
                  isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                  placeDirection: placeDirection,
                )
              : Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            _goToMyCurrentLocation();
          },
          child: const Icon(
            Icons.place,
            color: Colors.white,
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _myCurrentLocationCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      polylines: isSearchedPlaceMarkerClicked == true
          ? {
              Polyline(
                polylineId: const PolylineId("my_polyline"),
                color: Colors.black,
                width: 3,
                points: polylinePoints,
              ),
            }
          : {},
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget _buildSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      builder: (context, transition) {
        return ClipRRect(
          //this ClipRRect will contain the suggested places that maps gave us.
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSuggestionsBloc(),
              _buildSelectedPlaceLocationBloc(),
              _buildDirectionsBloc(),
            ],
          ),
        );
      },
      elevation: 6.0,
      hintStyle: const TextStyle(fontSize: 18),
      queryStyle: const TextStyle(fontSize: 18),
      hint: 'Find a place',
      border: const BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      transition: CircularFloatingSearchBarTransition(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 1000,
      progress: progressndicator,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        _getSuggestedPlaces(query: query);
      },
      onFocusChanged: (_) {
        //Hide the distance and time when searching for a new place.

        setState(() {
          isTimeAndDistanceVisible = false;
          isSearchedPlaceMarkerClicked = false;
        });
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.blue.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is SuggestionsLoaded) {
          places = state.places;
          if (places.isNotEmpty) {
            return _buildPlacedList();
          } else {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPlacedList() {
    return ListView.builder(
      itemCount: places.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            placeSuggestion = places[index];
            //To close the listview widget.
            controller.close();
            _getSelectedPlaceLocation();
            if (polylinePoints.isNotEmpty) {
              polylinePoints.clear();
            }
            if (markers.isNotEmpty) {
              removeAllMarkersAndUpdateUi();
            }
          },
          child: CustomPlacesListItem(
            place: places[index],
          ),
        );
      },
    );
  }

  void _getSuggestedPlaces({required String query}) {
    final sessionToken = const Uuid().v4();
    var cubit = BlocProvider.of<MapsCubit>(context);

    cubit.getSuggestedPlaces(
      place: query,
      sessiontoken: sessionToken,
    );
  }

  void _getSelectedPlaceLocation() {
    final sessionToken = const Uuid().v4();
    final placeId = placeSuggestion.placeId;
    var cubit = BlocProvider.of<MapsCubit>(context);
    cubit.getPlaceLocation(
      placeId: placeId,
      sessiontoken: sessionToken,
    );
  }

  Widget _buildSelectedPlaceLocationBloc() {
    //We should use the bloc listener if we will not build new component on the screen.
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = state.placeLocation;
          _goToTheSearchedPlace();
          _getDirections();
        }
      },
      child: Container(),
    );
  }

  Widget _buildDirectionsBloc() {
    //We should use the bloc listener if we will not build new component on the screen.
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceDirectionLoaded) {
          setState(() {
            placeDirection = (state).placeDirection;
          });
          _getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  void _getPolylinePoints() {
    polylinePoints = placeDirection!.polylinePoints
        .map(
          (polylinePoint) => LatLng(
            polylinePoint.latitude,
            polylinePoint.longitude,
          ),
        )
        .toList();
  }

  Future<void> _goToTheSearchedPlace() async {
    _buildCameraNewPosition();
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    _buildSearchedPlaceMarker();
  }

  void _buildCameraNewPosition() {
    newCameraPosition = CameraPosition(
      tilt: 0.0,
      bearing: 0.0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  void _buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: newCameraPosition.target,
      markerId: const MarkerId("1"),
      onTap: () {
        _buildCurrentLocationMarker();

        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(title: placeSuggestion.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    _appendToMarkersAndUpdateUi(searchedPlaceMarker);
  }

  void _buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(position!.latitude, position!.longitude),
      markerId: const MarkerId("2"),
      onTap: () {},
      infoWindow: const InfoWindow(title: "Your current location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );
    _appendToMarkersAndUpdateUi(currentLocationMarker);
  }

  void _appendToMarkersAndUpdateUi(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  void _getDirections() {
    BlocProvider.of<MapsCubit>(context).getPlaceDirection(
      origin: LatLng(position!.latitude, position!.longitude),
      destinaton: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
    );
  }

  void removeAllMarkersAndUpdateUi() {
    setState(() {
      markers.clear();
    });
  }
}
