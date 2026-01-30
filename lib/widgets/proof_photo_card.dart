import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../models/proof_photo.dart';

class ProofPhotoCard extends StatelessWidget {
  const ProofPhotoCard({super.key, required this.photo});

  final ProofPhoto photo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = intl.DateFormat('dd MMM yyyy - HH:mm');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bukti Foto',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(photo.file.path),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text('Waktu: ${formatter.format(photo.capturedAt)}'),
            Text(
              'Lokasi: ${photo.position.latitude.toStringAsFixed(5)}, '
              '${photo.position.longitude.toStringAsFixed(5)}',
            ),
          ],
        ),
      ),
    );
  }
}
