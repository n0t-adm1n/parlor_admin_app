import 'package:flutter/material.dart';
import 'package:admin_app/screens/layout/mobile_admin_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Call Firebase.initializeApp() after adding google-services.json
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
