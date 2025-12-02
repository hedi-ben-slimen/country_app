import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screen/app_wrapper.dart';
import 'provider/country_provider.dart';
import 'service/service.dart';

void main() {
  // SM-02: Set up provider correctly in main file
  runApp(
    MultiProvider(
      providers: [
        // App state
        ChangeNotifierProvider(
          create: (_) => CountryProvider(apiService: ApiService()),
        ),
      ],
      child: CountryExplorerApp(),
    ),
  );
}

class CountryExplorerApp extends StatefulWidget {
  const CountryExplorerApp({super.key});

  @override
  State<CountryExplorerApp> createState() => _CountryExplorerAppState();
}

class _CountryExplorerAppState extends State<CountryExplorerApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Explorer',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: _mode,
      // Home is set to AppWrapper which contains the BottomNavigationBar
      home: AppWrapper(
        onToggleTheme: _toggleTheme,
        isDark: _mode == ThemeMode.dark,
      ),
    );
  }
}
