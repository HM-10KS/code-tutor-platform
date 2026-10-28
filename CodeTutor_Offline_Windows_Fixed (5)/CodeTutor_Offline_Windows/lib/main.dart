import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.initialize();
  runApp(const CodeTutorApp());
}

class CodeTutorApp extends StatelessWidget {
  const CodeTutorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Code Tutor Offline',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2457A7)),
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
    ),
    home: const LoginScreen(),
  );
}

class Session {
  static String name = 'طالب';
  static String role = 'طالب';
}
