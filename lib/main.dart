import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SyriaChatApp());
}

class SyriaChatApp extends StatelessWidget {
  const SyriaChatApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SYRIA CHAT',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF090909),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC9A45C), brightness: Brightness.dark),
      useMaterial3: true,
    ),
    home: const AuthGate(),
  );
}
