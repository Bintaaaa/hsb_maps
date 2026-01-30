import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    super.key,
    required this.isLoading,
    required this.position,
    required this.error,
    required this.onRetry,
  });

  final bool isLoading;
  final Position? position;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokasi Saat Ini',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Row(
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Mengambil lokasi...'),
                ],
              )
            else if (error != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              )
            else if (position != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lat: ${position!.latitude.toStringAsFixed(6)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Lng: ${position!.longitude.toStringAsFixed(6)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Akurasi: ${position!.accuracy.toStringAsFixed(1)} m',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            else
              const Text('Lokasi belum tersedia.'),
          ],
        ),
      ),
    );
  }
}
