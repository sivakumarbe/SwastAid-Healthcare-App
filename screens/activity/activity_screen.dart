import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Activity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Health & Activity",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "To prevent diabetes, combine at least 150 minutes/week of aerobic exercise (walking, swimming, cycling) with strength training for muscle health.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Aerobic Exercise",
              content: "• Gets your heart rate up and burns calories.\n"
                  "• Examples: Brisk walking, jogging, cycling, swimming, dancing.",
            ),
            _buildSection(
              title: "Strength Training",
              content: "• Builds muscle and improves insulin sensitivity.\n"
                  "• Examples: Lifting weights, resistance bands, push-ups, squats.",
            ),
            _buildSection(
              title: "Flexibility & Balance",
              content: "• Improves joint movement and reduces fall risk.\n"
                  "• Examples: Yoga, Tai Chi, stretching.",
            ),
            _buildSection(
              title: "Daily Movement",
              content: "• Break up sitting every 30 mins.\n"
                  "• Stand while talking on phone, take stairs.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
