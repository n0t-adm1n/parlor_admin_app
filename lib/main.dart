import 'package:flutter/material.dart';
import 'package:admin_app/screens/layout/mobile_admin_layout.dart';
// TODO: Uncomment after running `flutterfire configure` to generate firebase_options.dart
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  // 1. Ensure the Flutter engine is fully initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. TODO: Uncomment after adding google-services.json and running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 3. Run the app
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Parlor Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: const Color(0xFF0F0B1E),
      ),
      home: const MobileAdminLayout(),
    );
  }
}
