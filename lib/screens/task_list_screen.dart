import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hsb_kurir/data/task.dart';
import 'package:hsb_kurir/screens/controller/task_controller.dart';
import 'package:hsb_kurir/screens/task_detail_screen.dart';
import 'package:hsb_kurir/widgets/location_status_card.dart';
import 'package:hsb_kurir/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: Consumer<TaskController>(
        builder: (context, state, _) {
          final position = state.currentPosition;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return LocationStatusCard(
                  isLoading: state.isLoading,
                  position: state.currentPosition,
                  error: state.error,
                  onRetry: () => state.getCurrentPosition(),
                );
              }

              final task = tasks[index - 1];
              final distanceMeters =
                  position == null
                      ? null
                      : Geolocator.distanceBetween(
                        position.latitude,
                        position.longitude,
                        task.location.latitude,
                        task.location.longitude,
                      );
              return TaskCard(
                task: task,
                distanceMeters: distanceMeters,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(task: task),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
