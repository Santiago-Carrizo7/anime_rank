import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/anime.dart';
import '../services/jikan_api_service.dart';

class SearchProvider extends ChangeNotifier {
  final JikanApiService _apiService = JikanApiService();

  List<Anime> _results = [];
  bool _isLoading = false;
  String? _error;
  String _query = '';
  Timer? _debounceTimer;

  List<Anime> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;

  void search(String query) {
    _query = query;
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _results = [];
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await _apiService.searchAnime(query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _results = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _results = [];
    _error = null;
    _isLoading = false;
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}