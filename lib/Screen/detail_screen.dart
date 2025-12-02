import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/country_model.dart';
import '../provider/country_provider.dart';

// NV-04: StatefulWidget for details
class DetailScreen extends StatefulWidget {
  final Country country;

  const DetailScreen({super.key, required this.country});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
            // Large Flag
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
