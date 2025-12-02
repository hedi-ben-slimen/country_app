import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/country_provider.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, provider, child) {
        final favs = provider.favorites;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorite Countries'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: favs.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your favorite countries will appear here!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: favs.length,
                  itemBuilder: (context, index) {
                    final country = favs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          country.flagUrl.isNotEmpty
                              ? country.flagUrl
                              : 'https://placehold.co/200x120/000000/ffffff/png?text=No+Flag',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(country.commonName),
                      subtitle: Text(country.capital),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(country: country),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
