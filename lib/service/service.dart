import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/country_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.apicountries.com/countries';

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Fetch current weather using Open-Meteo (no API key). Returns the
  /// 'current_weather' map if available, otherwise throws on network errors.
  Future<Map<String, dynamic>> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&temperature_unit=celsius',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.containsKey('current_weather')) {
          return Map<String, dynamic>.from(data['current_weather']);
        }
        return {};
      } else {
        throw Exception('Weather request failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
