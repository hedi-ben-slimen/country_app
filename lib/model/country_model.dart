class Country {
  final String commonName;
  final String officialName;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;
  // Map of currency code -> { name, symbol }
  final Map<String, dynamic> currencies;
  // Optional coordinates (latitude, longitude) - usually from 'latlng' in REST API
  final double? latitude;
  final double? longitude;

  Country({
    required this.commonName,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
    this.currencies = const {},
    this.latitude,
    this.longitude,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String cName = 'Unknown';
    String oName = 'Unknown';

    if (json['name'] is String) {
      cName = json['name'];
      oName = json['name'];
    } else if (json['name'] is Map) {
      cName = json['name']['common'] ?? 'Unknown';
      oName = json['name']['official'] ?? cName;
    }

    String cap = 'No Capital';
    if (json['capital'] is String) {
      cap = json['capital'];
    } else if (json['capital'] is List &&
        (json['capital'] as List).isNotEmpty) {
      cap = (json['capital'] as List).first.toString();
    }

    String flag = '';
    if (json['flags'] is String) {
      flag = json['flags'];
    } else if (json['flags'] is Map) {
      flag = json['flags']['png'] ?? json['flags']['svg'] ?? '';
    } else if (json['flag'] is String) {
      flag = json['flag'];
    }

    int pop = 0;
    final dynamic populationData = json['population'];

    if (populationData != null) {
      if (populationData is int) {
        pop = populationData;
      } else if (populationData is double) {
        pop = populationData.toInt();
      } else if (populationData is String) {
        pop = int.tryParse(populationData) ?? 0;
      }
    }

    return Country(
      commonName: cName,
      officialName: oName,
      capital: cap,
      region: json['region'] ?? 'Unknown',
      population: pop,
      flagUrl: flag,
      currencies: json['currencies'] is Map
          ? Map<String, dynamic>.from(json['currencies'])
          : {},
      latitude: (json['latlng'] is List && (json['latlng'] as List).isNotEmpty)
          ? (json['latlng'][0] is num
                ? (json['latlng'][0] as num).toDouble()
                : null)
          : null,
      longitude: (json['latlng'] is List && (json['latlng'] as List).length > 1)
          ? (json['latlng'][1] is num
                ? (json['latlng'][1] as num).toDouble()
                : null)
          : null,
    );
  }
}
