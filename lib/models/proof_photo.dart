import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ProofPhoto {
  const ProofPhoto({
    required this.file,
    required this.position,
    required this.capturedAt,
  });

  final XFile file;
  final Position position;
  final DateTime capturedAt;
}
