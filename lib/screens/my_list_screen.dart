import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anime_status.dart';
import '../providers/anime_list_provider.dart';
import '../widgets/tracked_anime_grid_item.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimeListProvider>().loadAllLists();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Watched'),
            Tab(text: 'To Watch'),
            Tab(text: 'Dropped'),
          ],
        ),
      ),
      body: Consumer<AnimeListProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _AnimeListView(
                animes: provider.watchedList,
                emptyMessage: 'No watched anime yet',
              ),
              _AnimeListView(
                animes: provider.toWatchList,
                emptyMessage: 'No anime in your watch list',
              ),
              _AnimeListView(
                animes: provider.droppedList,
                emptyMessage: 'No dropped anime',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimeListView extends StatelessWidget {
  final List animes;
  final String emptyMessage;

  const _AnimeListView({
    required this.animes,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (animes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: animes.length,
      itemBuilder: (context, index) {
        final anime = animes[index];
        return TrackedAnimeGridItem(
          anime: anime,
          onTap: () => _showOptionsSheet(context, anime),
        );
      },
    );
  }

  void _showOptionsSheet(BuildContext context, dynamic anime) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionsBottomSheet(anime: anime),
    );
  }
}

class _OptionsBottomSheet extends StatelessWidget {
  final dynamic anime;

  const _OptionsBottomSheet({required this.anime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            anime.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${anime.status.displayName}',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Change status:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatusOption(
                label: 'Watched',
                icon: Icons.check_circle,
                color: Colors.green,
                currentStatus: anime.status,
                onTap: () => _updateStatus(context, AnimeStatus.watched),
              ),
              const SizedBox(width: 12),
              _StatusOption(
                label: 'To Watch',
                icon: Icons.bookmark,
                color: Colors.blue,
                currentStatus: anime.status,
                onTap: () => _updateStatus(context, AnimeStatus.toWatch),
              ),
              const SizedBox(width: 12),
              _StatusOption(
                label: 'Dropped',
                icon: Icons.cancel,
                color: Colors.red,
                currentStatus: anime.status,
                onTap: () => _updateStatus(context, AnimeStatus.dropped),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => _removeAnime(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Remove from list',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, AnimeStatus newStatus) async {
    await context.read<AnimeListProvider>().updateStatus(anime.malId, newStatus);
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved to ${newStatus.displayName}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _removeAnime(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove anime?'),
        content: Text('Remove "${anime.title}" from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<AnimeListProvider>().removeAnime(anime.malId);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from list'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final AnimeStatus currentStatus;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.currentStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentStatus.displayName.toLowerCase().replaceAll(' ', '') == label.toLowerCase().replaceAll(' ', '');
    
    return Expanded(
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.3) : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}