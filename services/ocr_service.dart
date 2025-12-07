import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class OcrService {
  /// Extract RAW text from image using Google ML Kit
  static Future<String?> extractTextFromImage(File image) async {
    try {
      // Preprocess image to remove watermark/noise
      final processedImage = await _preprocessImage(image);

      final inputImage = InputImage.fromFile(processedImage);
      final recognizer = TextRecognizer();
      final recognized = await recognizer.processImage(inputImage);
      await recognizer.close();
      // ignore: avoid_print
      print("RAW OCR TEXT:\n${recognized.text}"); // Debugging

      // Clean up temp file if we created one
      if (processedImage.path != image.path) {
        try {
          await processedImage.delete();
        } catch (_) {}
      }

      return recognized.text;
    } catch (e) {
      // ignore: avoid_print
      print("OCR ERROR: $e");
      return null;
    }
  }

  static Future<File> _preprocessImage(File input) async {
    try {
      final bytes = await input.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return input;

      // 1. Convert to grayscale
      final grayscale = img.grayscale(image);

      // 2. Apply thresholding (Binarization)
      // This sets pixels brighter than threshold to white, darker to black.
      // 0.55 is a heuristic; watermarks are usually light (high luminance).
      // So we want to keep things darker than 0.55 (text) and wash out things brighter.
      // Note: luminanceThreshold logic might vary by version, but generally:
      // pixels < threshold => 0 (black), pixels > threshold => 1 (white) ?
      // Actually we want text (dark) to remain black.
      // Let's use a safe threshold.
      final binarized = img.luminanceThreshold(grayscale, threshold: 0.6);

      // Save to temp file
      final tempDir = Directory.systemTemp;
      final tempPath =
          '${tempDir.path}/ocr_processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final processedFile = File(tempPath);
      await processedFile.writeAsBytes(img.encodeJpg(binarized));

      return processedFile;
    } catch (e) {
      // ignore: avoid_print
      print("Preprocessing Error: $e");
      return input; // Fallback to original
    }
  }

  /// Extract a single best glucose value (mg/dL) from raw text
  static int? extractGlucoseValue(String text) {
    if (text.isEmpty) return null;

    final lines = text.split('\n');
    // Keywords with weights
    // Keywords with weights (must be all lowercase to match line.toLowerCase())
    final Map<String, int> keywordWeights = {
      'glucose': 100,
      'sugar': 100,
      'fasting': 100,
      'pp': 100,
      'post prandial': 100,
      'fbs (fasting blood sugar)': 100,
      'ppbs (postprandial blood sugar)': 100,
      'hba1c (hemoglobin a1c)': 100,
      'random blood sugar': 100,
      'ogtt (oral glucose tolerance test)': 100,
      'glucose pp': 100,
      'sugar random': 100,
      'blood glucose': 100,
      'glucose random plasma': 100,
      'mg/dl': 10, // Generic unit, lower score
    };

    // Candidate structure: {value: score}
    final Map<int, int> candidates = {};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toLowerCase();

      int lineScore = 0;
      for (final entry in keywordWeights.entries) {
        if (line.contains(entry.key)) {
          lineScore += entry.value;
        }
      }

      if (lineScore > 0) {
        // Look for numbers on THIS line
        _extractAndScore(line, candidates, baseScore: lineScore);

        // Look for numbers on the NEXT line (often values are below the label)
        // Decay the score slightly for the next line
        if (i + 1 < lines.length) {
          _extractAndScore(lines[i + 1].toLowerCase(), candidates,
              baseScore: (lineScore * 0.8).round());
        }
      }
    }

    // If no keywords found, fallback to global search (less reliable)
    if (candidates.isEmpty) {
      _extractAndScore(text.toLowerCase(), candidates, baseScore: 10);
    }

    if (candidates.isEmpty) return null;

    // Return the candidate with the highest score
    final sortedKeys = candidates.keys.toList()
      ..sort((a, b) => candidates[b]!.compareTo(candidates[a]!));

    return sortedKeys.first;
  }

  static void _extractAndScore(String text, Map<int, int> candidates,
      {required int baseScore}) {
    // 1. Remove reference ranges to avoid picking numbers from them.
    // Patterns: "70-140", "70 - 140", "70.00-140.00"
    // We replace them with spaces so we don't merge surrounding text.
    final rangeRegex = RegExp(r'\d+(?:\.\d+)?\s*-\s*\d+(?:\.\d+)?');
    final cleanedText = text.replaceAll(rangeRegex, ' ');

    // 2. Find numbers in the cleaned text
    // Matches "146", "146.00", "8.90"
    final regex = RegExp(r'\b\d+(\.\d+)?\b');
    final matches = regex.allMatches(cleanedText);

    int matchIndex = 0;
    for (final m in matches) {
      final valStr = m.group(0);
      if (valStr == null) continue;
      final valDouble = double.tryParse(valStr);

      if (valDouble != null) {
        // Check range (40-600)
        if (valDouble >= 40 && valDouble <= 600) {
          final valInt = valDouble.round();

          // 3. Prioritize the FIRST number found on the line.
          // If it's the first match, give it the full baseScore.
          // Subsequent matches get a penalty (e.g., half score).
          // This helps when "Result" comes before "Reference" (if range wasn't fully caught)
          // or if there are other numbers like dates/IDs that happen to be in range.
          int finalScore = baseScore;
          if (matchIndex > 0) {
            finalScore = (baseScore * 0.5).round();
          }

          // Accumulate score
          candidates[valInt] = (candidates[valInt] ?? 0) + finalScore;
          matchIndex++;
        }
      }
    }
  }
}
