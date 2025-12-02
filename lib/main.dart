import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/country_provider.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SM-02: Set up provider correctly in main file
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryProvider()),
      ],
      child: MaterialApp(
        title: 'Country Explorer',
        debugShowCheckedModeBanner: false,
        // BON-03: Theme toggle preparation (basic setup)
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}