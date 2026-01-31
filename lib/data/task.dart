import '../models/delivery_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const List<DeliveryTask> tasks = <DeliveryTask>[
  DeliveryTask(
    id: 'T-001',
    title: 'Antar Paket Elektronik',
    address: 'Jl. Merdeka No. 10, Jakarta Pusat',
    notes: 'Penerima: Budi. Hubungi jika sudah sampai.',
    location: LatLng(-6.175392, 106.827153),
  ),
  DeliveryTask(
    id: 'T-002',
    title: 'Kirim Dokumen Kontrak',
    address: 'Jl. Jenderal Sudirman No. 45, Jakarta Selatan',
    notes: 'Penerima: Sari. Paket rapih dan jangan terlipat.',
    location: LatLng(-6.21462, 106.821992),
  ),
  DeliveryTask(
    id: 'T-003',
    title: 'Ambil & Antar Paket UMKM',
    address: 'Jl. Cikini Raya No. 88, Jakarta Pusat',
    notes: 'Konfirmasi ke pemilik toko sebelum datang.',
    location: LatLng(-6.197209, 106.842833),
  ),
];
