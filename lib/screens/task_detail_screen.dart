import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hsb_kurir/models/delivery_task.dart';
import 'package:hsb_kurir/screens/controller/task_controller.dart';
import 'package:hsb_kurir/widgets/location_status_card.dart';
import 'package:hsb_kurir/widgets/proof_photo_card.dart';
import 'package:hsb_kurir/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final DeliveryTask task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: Consumer<TaskController>(
        builder: (context, state, _) {
          final position = state.currentPosition;
          final distanceMeters = position == null
              ? null
              : Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  task.location.latitude,
                  task.location.longitude,
                );
          final proofPhoto = state.proofPhotoFor(task.id);
          final canCapture =
              position != null && !state.isLoading && state.error == null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TaskCard(
                task: task,
                distanceMeters: distanceMeters,
                onTap: null,
                showChevron: false,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Tujuan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text('ID: ${task.id}'),
                      Text(
                        'Koordinat: ${task.location.latitude.toStringAsFixed(5)}, '
                        '${task.location.longitude.toStringAsFixed(5)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LocationStatusCard(
                isLoading: state.isLoading,
                position: position,
                error: state.error,
                onRetry: () => state.getCurrentPosition(),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: canCapture
                    ? () => state.captureStampedPhotoFor(task)
                    : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto Bukti'),
              ),
              if (proofPhoto != null) ...[
                const SizedBox(height: 12),
                ProofPhotoCard(photo: proofPhoto),
              ],
            ],
          );
        },
      ),
    );
  }
}
