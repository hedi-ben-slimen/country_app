import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/country_provider.dart';
import '../model/country_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data as soon as the app starts
    // We use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).getAllCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'), // MS-01
        centerTitle: true,
      ),
      body: Consumer<CountryProvider>(
        builder: (context, provider, child) {
          // DH-04: Show loading spinner
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // DH-03: Show error message
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.errorMessage}'),
                  ElevatedButton(
                    onPressed: provider.getAllCountries,
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          // MS-02: Grid View
          return RefreshIndicator(
            // MS-05: Pull to refresh
            onRefresh: provider.getAllCountries,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                childAspectRatio: 0.8, // Taller cards
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.countries.length,
              itemBuilder: (context, index) {
                final country = provider.countries[index];
                return CountryCard(country: country);
              },
            ),
          );
        },
      ),
    );
  }
}

// MS-04: Stateless Widget for country cards
class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // NV-01: Navigate to detail screen
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(country: country),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flag Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  country.flagUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stack) => 
                      const Center(child: Icon(Icons.flag)),
                ),
              ),
            ),
            // MS-03: Name and Capital
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    country.commonName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    country.capital,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}