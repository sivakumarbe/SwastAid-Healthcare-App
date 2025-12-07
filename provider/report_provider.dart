// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/ocr_service.dart';
import 'meal_provider.dart';

class ReportProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? lastReportImage;
  int? glucoseValue;
  String? lastReportText;
  bool isLoading = false;
  String? errorMessage;

  // simple category text, if you want to show later
  String get sugarCategory {
    if (glucoseValue == null) return "-";
    final g = glucoseValue!;
    if (g < 140) return "Normal";
    if (g >= 140 && g < 180) return "Mild";
    if (g >= 180 && g < 240) return "Moderate";
    return "High";
  }

  // ─────────────────────────────────────────────
  // PUBLIC: initial load when app starts
  // ─────────────────────────────────────────────
  Future<void> loadLastReport() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('lastReportImagePath');
    final g = prefs.getInt('lastGlucose');

    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      lastReportImage = File(path);
    }
    glucoseValue = g;
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // PICK FROM CAMERA
  // ─────────────────────────────────────────────
  Future<void> pickFromCamera(BuildContext context) async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    await _handleNewImage(File(file.path), context);
  }

  // ─────────────────────────────────────────────
  // PICK FROM GALLERY
  // ─────────────────────────────────────────────
  Future<void> pickFromGallery(BuildContext context) async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    await _handleNewImage(File(file.path), context);
  }

  // ─────────────────────────────────────────────
  // MANUAL ENTRY
  // ─────────────────────────────────────────────
  Future<void> setManualGlucose(int value, BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Simulate a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    glucoseValue = value;
    // Keep lastReportImage if it exists, or leave it null if not.
    lastReportImage = null; // Clear image on manual entry as requested

    // persist glucose only (we don't have a new image path to save)
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastReportImagePath'); // Remove saved image path
    await prefs.setInt('lastGlucose', value);

    // update meal provider
    await Provider.of<MealProvider>(context, listen: false).setGlucose(value);

    isLoading = false;
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // INTERNAL: common processing for new image
  // ─────────────────────────────────────────────
  Future<void> _handleNewImage(File image, BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    lastReportImage = image;
    lastReportText = null;
    glucoseValue = null;

    try {
      final text = await OcrService.extractTextFromImage(image);
      lastReportText = text;

      if (text == null || text.trim().isEmpty) {
        errorMessage = "Could not read any text from this report.";
      } else {
        final value = OcrService.extractGlucoseValue(text);
        if (value == null) {
          errorMessage = "Could not detect a valid glucose value.";
        } else {
          glucoseValue = value;

          // persist image path + glucose
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('lastReportImagePath', image.path);
          await prefs.setInt('lastGlucose', value);

          // update meal provider (use same value)

          Provider.of<MealProvider>(context, listen: false).setGlucose(value);
        }
      }
    } catch (e) {
      errorMessage = "Something went wrong while processing the report.";
      // ignore: avoid_print
      print("REPORT ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
