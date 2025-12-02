import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/country_model.dart';
import '../provider/country_provider.dart';
import '../service/service.dart';

class DetailScreen extends StatefulWidget {
  final Country country;

  const DetailScreen({super.key, required this.country});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _weather;
  bool _loadingWeather = false;
  String? _weatherError;

  @override
  void initState() {
    super.initState();
    if (widget.country.latitude != null && widget.country.longitude != null) {
      _loadWeather(widget.country.latitude!, widget.country.longitude!);
    }
  }

  Future<void> _loadWeather(double lat, double lon) async {
    setState(() {
      _loadingWeather = true;
      _weatherError = null;
    });
    try {
      final data = await _apiService.fetchWeather(lat, lon);
      setState(() {
        _weather = data;
      });
    } catch (e) {
      setState(() {
        _weatherError = e.toString();
      });
    } finally {
      setState(() {
        _loadingWeather = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountryProvider>(context);
    final isFavorite = provider.isFavorite(widget.country);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.commonName),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              final nowFavorite = provider.toggleFavorite(widget.country);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    nowFavorite
                        ? '${widget.country.commonName} added to favorites!'
                        : '${widget.country.commonName} removed from favorites.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.country.commonName,
              child: Image.network(
                widget.country.flagUrl.isNotEmpty
                    ? widget.country.flagUrl
                    : 'https://placehold.co/800x400/000000/FFFFFF/png?text=No+Flag',
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 250,
                  child: Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Official Name', widget.country.officialName),
                  _buildInfoRow('Capital', widget.country.capital),
                  _buildInfoRow('Region', widget.country.region),
                  _buildInfoRow('Population', '${widget.country.population}'),
                  const SizedBox(height: 8),
                  if (widget.country.currencies.isNotEmpty) ...[
                    const Text(
                      'Currencies:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...widget.country.currencies.entries.map((e) {
                      final code = e.key;
                      final details = e.value is Map ? e.value : {};
                      final name = details['name'] ?? '';
                      final symbol = details['symbol'] ?? '';
                      final display = name.isNotEmpty
                          ? '$name ${symbol.isNotEmpty ? '($symbol)' : ''}'
                          : code;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          '$code: $display',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 8),
                  const Text(
                    'Weather:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  if (_loadingWeather)
                    const SizedBox(
                      height: 24,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_weatherError != null)
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_weatherError!)),
                      ],
                    )
                  else if (_weather != null && _weather!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temperature: ${_weather!['temperature']} °C',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Wind speed: ${_weather!['windspeed']} km/h',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Time: ${_weather!['time']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'No weather data available for ${widget.country.capital}',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
