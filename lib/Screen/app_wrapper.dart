import 'package:flutter/material.dart';
import 'countries_screen.dart';
import 'favourites_screen.dart';

class AppWrapper extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const AppWrapper({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CountriesScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onToggleTheme,
        tooltip: widget.isDark ? 'Switch to light mode' : 'Switch to dark mode',
        child: Icon(widget.isDark ? Icons.nights_stay : Icons.wb_sunny),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Countries'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        // Use white colors for icons/text when in dark mode so they remain visible
        selectedItemColor: widget.isDark
            ? Colors.white
            : Theme.of(context).primaryColor,
        unselectedItemColor: widget.isDark ? Colors.white70 : Colors.grey,
        selectedIconTheme: IconThemeData(
          color: widget.isDark ? Colors.white : Theme.of(context).primaryColor,
        ),
        unselectedIconTheme: IconThemeData(
          color: widget.isDark ? Colors.white70 : Colors.grey,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
