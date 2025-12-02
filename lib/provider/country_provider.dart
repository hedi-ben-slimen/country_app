import 'package:flutter/material.dart';
import '../model/country_model.dart';
import '../service/service.dart';

class CountryProvider with ChangeNotifier {
  final ApiService apiService;

  List<Country> _countries = [];
  final List<Country> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  CountryProvider({required this.apiService});

  List<Country> get countries => _countries;
  List<Country> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isFavorite(Country country) {
    return _favorites.any((c) => c.commonName == country.commonName);
  }

  void addFavorite(Country country) {
    if (!isFavorite(country)) {
      _favorites.add(country);
      notifyListeners();
    }
  }

  void removeFavorite(Country country) {
    _favorites.removeWhere((c) => c.commonName == country.commonName);
    notifyListeners();
  }

  bool toggleFavorite(Country country) {
    if (isFavorite(country)) {
      removeFavorite(country);
      return false;
    } else {
      addFavorite(country);
      return true;
    }
  }

  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _countries = await apiService.fetchCountries();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
