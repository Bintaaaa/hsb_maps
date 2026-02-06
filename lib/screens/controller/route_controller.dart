import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hsb_kurir/config/google_maps_config.dart';

class RouteController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LatLng> _routePoints = [];
  List<LatLng> get routePoints => _routePoints;

  Future<void> loadRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final polylinePoints = PolylinePoints(apiKey: googleMapsApiKey);

      final response = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          travelMode: TravelMode.driving,
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
        ),
      );

      final points =
          response.primaryRoute?.polylinePoints ??
          (response.routes.first.polylinePoints); //NOTE

      _routePoints =
          points!
              .map((value) => LatLng(value.latitude, value.longitude))
              .toList();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
