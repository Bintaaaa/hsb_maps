import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hsb_kurir/models/proof_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class TaskController extends ChangeNotifier {

  TaskController(){
    getCurrentPosition();
  }

  StreamSubscription<Position>? _streamCurrentPosition;
  StreamSubscription<Position>? get streamCurrentPosition => _streamCurrentPosition;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  XFile? _picture;
  XFile? get picture => _picture;

  Future<void> getCurrentPosition() async{
    _isLoading = true;
    _error = null;
    notifyListeners();

    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      _isLoading = false;
      _error = 'Layanan lokasi tidak aktif. Aktifkan GPS lalu coba lagi.';
      notifyListeners();
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      _isLoading = false;
      _error = 'Izin lokasi ditolak. Berikan izin untuk melanjutkan.';
      notifyListeners();
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      _isLoading = false;
      _error =
          'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.';
      notifyListeners();
      return;
    }

    await _streamCurrentPosition?.cancel();
    _streamCurrentPosition = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1)
    ).listen((position){
      _currentPosition = position;
      _isLoading = false;
      notifyListeners();
    }, onError: (_) {
      _isLoading = false;
      _error = 'Gagal mendapatkan lokasi. Coba lagi.';
      notifyListeners();
    });
  }

  capturePhoto() async {
    final pickImage = ImagePicker();
    final source = await pickImage.pickImage(source: ImageSource.camera, imageQuality: 85);
    _picture = source;
    notifyListeners();
  }


  Future captureStampedPhoto() async {
    final picker = ImagePicker();
    final source = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (source == null) {
      throw Exception('Pengambilan foto dibatalkan.');
    }

    final capturedAt = DateTime.now();
    
    final overlayText = [
      'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(5)}, '
          '${_currentPosition!.longitude.toStringAsFixed(5)}',
      'Jam: $capturedAt',
    ].join('\n');

    final stampedFile = await _drawTextOnImage(
      original: source,
      text: overlayText,
    );

    _picture = stampedFile;
    notifyListeners();
  }


  Future<XFile> _drawTextOnImage({
    required XFile original,
    required String text,
  }) async {
    final bytes = await original.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(image, Offset.zero, Paint());

    final rectHeight = max(120.0, image.height * 0.18);
    final rect = Rect.fromLTWH(
      0,
      image.height - rectHeight,
      image.width.toDouble(),
      rectHeight,
    );
    final rectPaint = Paint()..color = Colors.black.withOpacity(0.6);
    canvas.drawRect(rect, rectPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 70,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: image.width.toDouble() - 32);
    textPainter.paint(
      canvas,
      Offset(16, image.height - rectHeight + 16),
    );

    final picture = recorder.endRecording();
    final stampedImage = await picture.toImage(image.width, image.height);
    final byteData =
        await stampedImage.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getTemporaryDirectory();
    final outputPath =
        '${directory.path}/kurir_${DateTime.now().millisecondsSinceEpoch}.png';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(byteData!.buffer.asUint8List());
    return XFile(outputFile.path);
  }



}
