import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'states/theme_state.dart';
import 'states/counter_state.dart';
import 'widgets/counter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('Failed to initialize ads: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeState(),
      child: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return ChangeNotifierProvider(
            create: (context) => CounterState(),
            child: MaterialApp(
              title: 'Kounter',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.light,
                  surface: Colors.purple.shade50,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.dark,
                  surface: Colors.purple.shade900,
                ),
              ),
              themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: CounterPage(),
            ),
          );
        },
      ),
    );
  }
}