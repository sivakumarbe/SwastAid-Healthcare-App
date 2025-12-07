import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

// PROVIDERS
import 'provider/settings_provider.dart';
import 'provider/meal_provider.dart';
import 'provider/report_provider.dart';

// SERVICES
import 'services/notifications/notification_service.dart';
import 'services/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.init();
    await NotificationService.requestPermissions();
  } catch (e) {
    debugPrint("Error initializing NotificationService: $e");
  }

  try {
    await TtsService.init();
  } catch (e) {
    debugPrint("Error initializing TtsService: $e");
  }

  runApp(const SwastAidApp());
}

class SwastAidApp extends StatelessWidget {
  const SwastAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) {
          final mp = MealProvider();
          mp.loadSavedMealCategory();
          return mp;
        }),
        ChangeNotifierProvider(create: (_) {
          final rp = ReportProvider();
          rp.loadLastReport(); // load last image + glucose on startup
          return rp;
        }),
      ],
      child: MaterialApp(
        title: 'SwastAid',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes, // make sure /uploadReport & meal routes exist
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
