import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hsb_kurir/models/delivery_task.dart';
import 'package:hsb_kurir/screens/controller/route_controller.dart';
import 'package:hsb_kurir/screens/controller/task_controller.dart';
import 'package:provider/provider.dart';

class MapsDetailScreen extends StatefulWidget {
  final DeliveryTask task;
  const MapsDetailScreen({super.key, required this.task});

  @override
  State<MapsDetailScreen> createState() => _MapsDetailScreenState();
}

class _MapsDetailScreenState extends State<MapsDetailScreen> {
  bool _didRequestRoute = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Maps')),
      body: Consumer<RouteController>(
        builder: (context, state, _) {
          final taskController = context.watch<TaskController>();
          final position = taskController.currentPosition;

          if (position == null) {
            return const Center(child: Text('Menunggu lokasi...'));
          }

          if (!_didRequestRoute) {
            _didRequestRoute = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<RouteController>().loadRoute(
                origin: LatLng(position.latitude, position.longitude),
                destination: LatLng(
                  widget.task.location.latitude,
                  widget.task.location.longitude,
                ),
              );
            });
          }

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.task.location,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('Titik Awal'),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan,
                ),
              ),
              Marker(
                markerId: MarkerId('Driver'),
                position: LatLng(-6.190760, 106.830227),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
              Marker(
                markerId: const MarkerId('Tujuan'),
                position: LatLng(
                  widget.task.location.latitude,
                  widget.task.location.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: state.routePoints,
                color: Colors.blue,
              ),
            },
          );
        },
      ),
    );
  }
}
