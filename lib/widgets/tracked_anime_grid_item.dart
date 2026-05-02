import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tracked_anime.dart';

class TrackedAnimeGridItem extends StatelessWidget {
  final TrackedAnime anime;
  final VoidCallback onTap;

  const TrackedAnimeGridItem({
    super.key,
    required this.anime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  anime.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: anime.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade800,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade800,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(anime.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        anime.status.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                anime.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    final statusString = status.toString().split('.').last;
    switch (statusString) {
      case 'watched':
        return Colors.green;
      case 'toWatch':
        return Colors.blue;
      case 'dropped':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}