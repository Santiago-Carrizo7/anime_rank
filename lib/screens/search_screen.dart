import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anime.dart';
import '../providers/search_provider.dart';
import '../providers/anime_list_provider.dart';
import '../widgets/anime_grid_item.dart';
import '../widgets/status_bottom_sheet.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Anime'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search for anime...',
              onChanged: (query) {
                context.read<SearchProvider>().search(query);
              },
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${provider.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.results.isEmpty && provider.query.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Search for anime',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.results.isEmpty && provider.query.isNotEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: provider.results.length,
                  itemBuilder: (context, index) {
                    final anime = provider.results[index];
                    return AnimeGridItem(
                      anime: anime,
                      onTap: () => _showStatusSheet(context, anime),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusSheet(BuildContext context, Anime anime) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatusBottomSheet(
        anime: anime,
        onStatusSelected: (status) async {
          final success = await context.read<AnimeListProvider>().trackAnime(anime, status);
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? 'Added to ${status.displayName}' : 'Failed to add anime',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Widget? leading;

  const SearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.leading,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.leading,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}