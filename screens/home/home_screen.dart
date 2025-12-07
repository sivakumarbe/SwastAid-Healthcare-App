import 'package:flutter/material.dart';
import '../../widgets/tile_card.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double tileSize = MediaQuery.of(context).size.width * 0.42;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10),
            Text('SwastAid'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              'Your personal health assistant',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
                children: [
                  TileCard(
                    label: 'Upload Reports',
                    icon: Icons.upload_file_outlined,
                    size: tileSize,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.uploadReport),
                    color: AppColors.tile,
                  ),
                  TileCard(
                    label: 'Medicine Reminder',
                    icon: Icons.medical_services_outlined,
                    size: tileSize,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.reminder),
                    color: AppColors.tile,
                  ),
                  TileCard(
                    label: 'Food Suggestion',
                    icon: Icons.restaurant_menu_outlined,
                    size: tileSize,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.meals),
                    color: AppColors.tile,
                  ),
                  TileCard(
                    label: 'Activity',
                    icon: Icons.directions_run, // Activity icon
                    size: tileSize,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.activity),
                    color: AppColors.tile, // Use standard tile color
                  ),
                ],
              ),
            ),
            // Optional small footer
            Center(
              child: Text(
                'Meal is the best medicine',
                style: AppTextStyles.subtitle
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
