import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/anime.dart';
import '../models/anime_status.dart';

class StatusBottomSheet extends StatelessWidget {
  final Anime anime;
  final Function(AnimeStatus) onStatusSelected;

  const StatusBottomSheet({
    super.key,
    required this.anime,
    required this.onStatusSelected,
  });

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
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: anime.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: anime.imageUrl!,
                        width: 60,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 80,
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      anime.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (anime.episodes != null)
                      Text(
                        '${anime.episodes} episodes',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Add to list:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatusButton(
                label: 'Watched',
                icon: Icons.check_circle,
                color: Colors.green,
                onTap: () => onStatusSelected(AnimeStatus.watched),
              ),
              const SizedBox(width: 12),
              _StatusButton(
                label: 'To Watch',
                icon: Icons.bookmark,
                color: Colors.blue,
                onTap: () => onStatusSelected(AnimeStatus.toWatch),
              ),
              const SizedBox(width: 12),
              _StatusButton(
                label: 'Dropped',
                icon: Icons.cancel,
                color: Colors.red,
                onTap: () => onStatusSelected(AnimeStatus.dropped),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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