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
        // SM-01: Implement Provider to manage your app state
        ChangeNotifierProvider(
          // Injecting ApiService into the CountryProvider constructor
          create: (_) => CountryProvider(apiService: ApiService()),
        ),
      ],
      child: const CountryExplorerApp(),
    ),
  );
}

class CountryExplorerApp extends StatelessWidget {
  const CountryExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MS-01: Basic app structure with "Country Explorer" title
    return MaterialApp(
      title: 'Country Explorer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // FINAL FIX: Use CardThemeData to configure card appearance
        // This ensures the correct type is assigned for this SDK.
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        useMaterial3: true,
      ),
      // Home is set to AppWrapper which contains the BottomNavigationBar
      home: const AppWrapper(),
    );
  }
}
