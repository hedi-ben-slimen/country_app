import 'package:flutter/material.dart';
import '../model/country_model.dart';
import '../service/service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Country> _countries = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters to access private variables safely
  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to fetch data
  Future<void> getAllCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Tells UI: "Show the loading spinner!"

    try {
      _countries = await _apiService.fetchCountries();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Tells UI: "Data is ready (or error happened), rebuild!"
    }
  }
}