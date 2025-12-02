import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/country_model.dart';

class ApiService {
  // Base URL from your requirements
  static const String _baseUrl = 'https://restcountries.com/v3.1/all'; 
  // NOTE: If your professor specifically wants 'apicountries.com', verify if the endpoint is different.
  // The structure below assumes standard country JSON format.

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Map the list of JSON objects to a list of Country objects
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      // DH-03: Handle errors gracefully
      throw Exception('Error fetching data: $e');
    }
  }
}