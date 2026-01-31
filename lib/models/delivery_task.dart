import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryTask {
  const DeliveryTask({
    required this.id,
    required this.title,
    required this.address,
    required this.notes,
    required this.location,
  });

  final String id;
  final String title;
  final String address;
  final String notes;
  final LatLng location;
}

class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

