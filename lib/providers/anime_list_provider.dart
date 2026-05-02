import 'package:flutter/foundation.dart';
import '../models/anime.dart';
import '../models/anime_status.dart';
import '../models/tracked_anime.dart';
import '../services/database_service.dart';

class AnimeListProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<TrackedAnime> _watchedList = [];
  List<TrackedAnime> _toWatchList = [];
  List<TrackedAnime> _droppedList = [];
  bool _isLoading = false;

  List<TrackedAnime> get watchedList => _watchedList;
  List<TrackedAnime> get toWatchList => _toWatchList;
  List<TrackedAnime> get droppedList => _droppedList;
  bool get isLoading => _isLoading;

  Future<void> loadAllLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _watchedList = await _dbService.getAnimesByStatus(AnimeStatus.watched);
      _toWatchList = await _dbService.getAnimesByStatus(AnimeStatus.toWatch);
      _droppedList = await _dbService.getAnimesByStatus(AnimeStatus.dropped);
    } catch (e) {
      debugPrint('Error loading lists: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> trackAnime(Anime anime, AnimeStatus status) async {
    try {
      final trackedAnime = TrackedAnime(
        malId: anime.malId,
        title: anime.title,
        imageUrl: anime.imageUrl,
        episodes: anime.episodes,
        status: status,
        dateAdded: DateTime.now(),
      );

      await _dbService.insertAnime(trackedAnime);
      await loadAllLists();
      return true;
    } catch (e) {
      debugPrint('Error tracking anime: $e');
      return false;
    }
  }

  Future<bool> updateStatus(int malId, AnimeStatus newStatus) async {
    try {
      await _dbService.updateStatus(malId, newStatus);
      await loadAllLists();
      return true;
    } catch (e) {
      debugPrint('Error updating status: $e');
      return false;
    }
  }

  Future<bool> removeAnime(int malId) async {
    try {
      await _dbService.deleteAnime(malId);
      await loadAllLists();
      return true;
    } catch (e) {
      debugPrint('Error removing anime: $e');
      return false;
    }
  }

  Future<bool> isAnimeTracked(int malId) async {
    return await _dbService.isAnimeTracked(malId);
  }

  List<TrackedAnime> getListForStatus(AnimeStatus status) {
    switch (status) {
      case AnimeStatus.watched:
        return _watchedList;
      case AnimeStatus.toWatch:
        return _toWatchList;
      case AnimeStatus.dropped:
        return _droppedList;
    }
  }
}