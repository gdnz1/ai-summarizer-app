import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// On-Device Optical Character Recognition (OCR) Service powered by Google ML Kit.
///
/// Extracts textual content from images captured via Camera or selected from Gallery
/// completely offline, with zero API cost and ultra-low latency.
class OcrService {
  final ImagePicker _picker;

  OcrService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Captures a photo with the device camera and extracts text.
  Future<String?> extractTextFromCamera() async {
    return _pickAndProcess(ImageSource.camera);
  }

  /// Picks an existing image from the device gallery and extracts text.
  Future<String?> extractTextFromGallery() async {
    return _pickAndProcess(ImageSource.gallery);
  }

  /// Internal pipeline to capture/pick an image and execute on-device text recognition.
  Future<String?> _pickAndProcess(ImageSource source) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'On-device ML Kit OCR is designed for Android & iOS. '
        'Please test OCR on your mobile device.',
      );
    }

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (image == null) {
      return null; // User cancelled picker
    }

    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      final result = recognizedText.text.trim();
      if (result.isEmpty) {
        throw Exception('No readable text found in the selected image.');
      }

      return result;
    } finally {
      textRecognizer.close();
    }
  }
}
