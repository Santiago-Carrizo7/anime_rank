import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/search_provider.dart';
import 'providers/anime_list_provider.dart';
import 'theme/app_theme.dart';
import 'screens/search_screen.dart';
import 'screens/my_list_screen.dart';

void main() {
  runApp(const AnimeRankApp());
}

class AnimeRankApp extends StatelessWidget {
  const AnimeRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => AnimeListProvider()),
      ],
      child: MaterialApp(
        title: 'AnimeRank',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SearchScreen(),
    MyListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            context.read<AnimeListProvider>().loadAllLists();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My List',
          ),
        ],
      ),
    );
  }
}