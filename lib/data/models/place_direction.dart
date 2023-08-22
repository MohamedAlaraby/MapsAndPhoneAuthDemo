// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirection {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  late String totalDistance;
  late String totalDuration;
  PlaceDirection({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });
  /*
      the factory keyword is used to create a factory constructor.
      A factory constructor is a way to create an instance of a class,
      but it doesn't necessarily create a new object every time it's called <Singleton desgin pattern>. 
      It can be used to provide custom object creation logic or perform some additional processing before returning an instance of the class.
      
   */
  factory PlaceDirection.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json["routes"][0]);
    final northeast = data["bounds"]["northeast"];
    final southwest = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest["lat"], southwest["lng"]),
      northeast: LatLng(northeast["lat"], northeast["lng"]),
    );
    String? distance;
    String? duration;
    if ((data["legs"] as List).isNotEmpty) {
      final firstLeg = data["legs"][0];
      distance = firstLeg["distance"]["text"];
      duration = firstLeg["duration"]["text"];
    }
    final polylinePoints = data["overview_polyline"]["points"];
    return PlaceDirection(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(polylinePoints),
      totalDistance: distance ?? "No distance found",
      totalDuration: duration ?? "No duration found",
    );
  }
}
