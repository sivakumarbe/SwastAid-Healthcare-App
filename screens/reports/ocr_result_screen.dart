import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/report_provider.dart';

class OcrResultScreen extends StatelessWidget {
  const OcrResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<ReportProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("OCR Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rp.glucoseValue == null
            ? const Center(
                child: Text(
                  "No OCR result yet.\nPlease upload a report.",
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rp.lastReportImage != null)
                    Center(
                      child: Image.file(
                        rp.lastReportImage!,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    "Glucose value: ${rp.glucoseValue} mg/dL",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Category: ${rp.sugarCategory}"),
                  const SizedBox(height: 12),
                  const Text(
                    "Raw OCR text:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(rp.lastReportText ?? "-"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
