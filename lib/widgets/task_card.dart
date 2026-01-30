import 'package:flutter/material.dart';

import '../models/delivery_task.dart';
import '../utils/formatters.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.distanceMeters,
    required this.onTap,
  });

  final DeliveryTask task;
  final double? distanceMeters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distanceLabel =
        distanceMeters == null ? null : formatDistance(distanceMeters!);
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.address),
            const SizedBox(height: 4),
            Text(
              task.notes,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (distanceLabel != null) ...[
              const SizedBox(height: 6),
              Text(
                'Jarak dari lokasi kamu: $distanceLabel',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
