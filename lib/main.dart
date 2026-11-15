import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/database/database_helper.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/dashboard/views/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Android 15+ Edge-to-Edge mode with transparent system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      statusBarContrastEnforced: false,
    ),
  );

  // Pre-initialize lightweight core SQLite databases in background
  DatabaseHelper.instance.initCoreDatabases().catchError((e) {
    debugPrint('[main] Database pre-init note: $e');
  });

  runApp(const LearnEnglishApp());
}

class LearnEnglishApp extends StatelessWidget {
  const LearnEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn English Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
