import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/country_model.dart';
import '../provider/country_provider.dart';
import 'detail_screen.dart';

enum SortOption { nameAsc, nameDesc, populationAsc, populationDesc }

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  // Sorting state
  SortOption _sortOption = SortOption.nameAsc;

  void _applySort(List<Country> list) {
    switch (_sortOption) {
      case SortOption.nameAsc:
        list.sort((a, b) => a.commonName.compareTo(b.commonName));
        break;
      case SortOption.nameDesc:
        list.sort((a, b) => b.commonName.compareTo(a.commonName));
        break;
      case SortOption.populationAsc:
        list.sort((a, b) => a.population.compareTo(b.population));
        break;
      case SortOption.populationDesc:
        list.sort((a, b) => b.population.compareTo(a.population));
        break;
    }
  }

  // Function to filter countries based on the search query
  List<Country> _filterCountries(List<Country> countries) {
    if (_searchQuery.isEmpty) {
      return countries;
    }
    return countries.where((country) {
      // Assuming Country model has commonName and capital properties
      final nameLower = country.commonName.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower) ||
          country.capital.toLowerCase().contains(queryLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Start fetching data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FIX: Calling the now correctly named fetchCountries
      Provider.of<CountryProvider>(context, listen: false).fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use the Consumer to listen for changes in the CountryProvider state
    return Consumer<CountryProvider>(
      builder: (context, provider, child) {
        // Filter the country list based on the search query
        final filteredCountries = _filterCountries(provider.countries);
        // Apply sorting to a copy so we don't mutate provider's list
        final List<Country> sortedCountries = List<Country>.from(
          filteredCountries,
        );
        _applySort(sortedCountries);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Country Explorer'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            children: [
              // Search Bar (BON-01)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by country or capital...',
                    prefixIcon: const Icon(Icons.search),
                    // Filter button on the right side of the search field
                    suffixIcon: PopupMenuButton<SortOption>(
                      icon: const Icon(Icons.filter_list),
                      tooltip: 'Filter / Sort',
                      onSelected: (opt) {
                        setState(() => _sortOption = opt);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: SortOption.nameAsc,
                          child: Text('Name ↑'),
                        ),
                        PopupMenuItem(
                          value: SortOption.nameDesc,
                          child: Text('Name ↓'),
                        ),
                        PopupMenuItem(
                          value: SortOption.populationAsc,
                          child: Text('Population ↑'),
                        ),
                        PopupMenuItem(
                          value: SortOption.populationDesc,
                          child: Text('Population ↓'),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value; // Update state to trigger filtering and UI rebuild
                    });
                  },
                ),
              ),
              // Main content (Loading, Error, or Grid)
              Expanded(
                child: RefreshIndicator(
                  // MS-05: Pull down to refresh
                  onRefresh: () => provider
                      .fetchCountries(), // FIX: Calling the now correctly named fetchCountries
                  child: () {
                    if (provider.isLoading) {
                      // DH-04: Show loading spinners
                      return const Center(child: CircularProgressIndicator());
                    } else if (provider.errorMessage != null) {
                      // DH-03: Handle errors gracefully
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => provider
                                  .fetchCountries(), // FIX: Calling the now correctly named fetchCountries
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (filteredCountries.isEmpty) {
                      return const Center(
                        child: Text('No countries found matching your search.'),
                      );
                    } else {
                      // MS-02: Grid view showing all countries
                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  0.7, // Adjust ratio for better card fitting
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: sortedCountries.length,
                        itemBuilder: (context, index) {
                          final country = sortedCountries[index];
                          // The CountryCard assumes Country has properties like flagUrl, commonName, capital, population
                          return CountryCard(country: country);
                        },
                      );
                    }
                  }(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// MS-04: Stateless Widget for the country cards (assuming the required `NumberFormat` is available)
class CountryCard extends StatelessWidget {
  final Country country;
  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    // NV-01: Tap a country -> see its details
    return GestureDetector(
      onTap: () {
        // Navigate to the detail screen when a country is tapped
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailScreen(country: country)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flag Image (MS-03)
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Hero(
                  tag: country.commonName,
                  child: Image.network(
                    country.flagUrl.isNotEmpty
                        ? country.flagUrl
                        : 'https://placehold.co/600x400/000000/FFFFFF/png?text=No+Flag',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              ),
            ),
            // Country Details (MS-03)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      country.commonName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Capital
                    Text(
                      'Capital: ${country.capital}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Population (formatted for readability)
                    Text(
                      // NumberFormat requires the 'intl' package dependency
                      'Pop: ${NumberFormat.compact().format(country.population)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
