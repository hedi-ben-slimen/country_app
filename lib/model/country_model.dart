class Country {
  final String commonName;
  final String officialName;
  final String capital;
  final String region;
  final String population;
  final String flagUrl;

  Country({
    required this.commonName,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
  });

  // Factory constructor to create a Country from JSON
  factory Country.fromJson(Map<String, dynamic> json) {

    
    return Country(
      commonName: json['name']?['common'] ?? 'Unknown',
      officialName: json['name']?['official'] ?? 'Unknown',
      // Capital is often a list in these APIs, we take the first one
      capital: (json['capital'] as List<dynamic>?)?.first ?? 'No Capital',
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
      flagUrl: json['flags']?['png'] ?? '',
    );
  }
}