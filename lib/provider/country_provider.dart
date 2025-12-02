import 'package:flutter/material.dart';
import '../model/country_model.dart';
import '../service/service.dart'; // Updated path to lowercase

class CountryProvider with ChangeNotifier {
  // FIX 1: Use constructor injection and remove internal instantiation
  final ApiService apiService;

  List<Country> _countries = [];
  bool _isLoading = false;
  String? _errorMessage;

  // FIX 2: Define the constructor to accept the named parameter
  CountryProvider({required this.apiService});

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // FIX 3: Rename method from getAllCountries to fetchCountries
  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _countries = await apiService.fetchCountries(); // Use injected service
    } catch (e) {
      // Keep the error message clean for display
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
