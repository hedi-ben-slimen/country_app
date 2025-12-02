import 'package:flutter/material.dart';
import '../model/country_model.dart';
import '../service/service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Country> _countries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAllCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      _countries = await _apiService.fetchCountries();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}