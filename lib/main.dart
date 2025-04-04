import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'states/theme_state.dart';
import 'states/counter_state.dart';
import 'widgets/counter_page.dart';

void main() {
  runApp(MyApp());
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
              title: 'Counter',
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