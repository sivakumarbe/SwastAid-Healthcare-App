import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/report_provider.dart';
import '../../core/theme/colors.dart';

class UploadReportScreen extends StatelessWidget {
  const UploadReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<ReportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Upload your blood report image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Image Preview Area
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: Colors.grey.shade300),
              ),
              child: rp.lastReportImage != null
                  ? Image.file(
                      rp.lastReportImage!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    )
                  : Image.asset(
                      'assets/report_placeholder.png', // Fallback or placeholder, logically
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey.shade300),
                            const Text("No Image"),
                          ],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 24),

            // OCR Status / Result
            if (rp.isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Analyzing report..."),
                ],
              )
            else if (rp.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rp.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            else if (rp.glucoseValue != null)
              _buildResultCard(rp),

            const SizedBox(height: 32),

            // Action Buttons - Vertically Stacked
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                icon: Icons.camera_alt,
                label: "Capture From Camera",
                onTap: () => rp.pickFromCamera(context),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                icon: Icons.photo_library,
                label: "Choose From Gallery",
                onTap: () => rp.pickFromGallery(context),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                icon: Icons.edit,
                label: "Enter Manually",
                onTap: () => _showManualEntryDialog(context),
                color: AppColors.primary, // All buttons green as per screenshot
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildResultCard(ReportProvider rp) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Extracted Glucose",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            "${rp.glucoseValue} mg/dL",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red, // Red text for value
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Category: ${rp.sugarCategory}",
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            "Now go to Food Suggestions to see your 30-day diabetic meal plan.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Enter Glucose Value"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Glucose (mg/dL)",
            hintText: "e.g. 120",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              final val = int.tryParse(text);
              if (val == null || val < 40 || val > 600) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please enter a valid value (40-600).")),
                );
                return;
              }

              // Save and close
              Provider.of<ReportProvider>(context, listen: false)
                  .setManualGlucose(val, context);
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
