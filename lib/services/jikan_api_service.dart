import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class JikanApiService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';
  static const Duration _rateLimitDelay = Duration(milliseconds: 500);

  DateTime? _lastRequestTime;

  Future<List<Anime>> searchAnime(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    await _respectRateLimit();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/anime?q=${Uri.encodeComponent(query)}&limit=20'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['data'] as List<dynamic>? ?? [];
        return results.map((json) => Anime.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 1));
        return searchAnime(query);
      } else {
        throw Exception('Failed to load anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> _respectRateLimit() async {
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!);
      if (elapsed < _rateLimitDelay) {
        await Future.delayed(_rateLimitDelay - elapsed);
      }
    }
    _lastRequestTime = DateTime.now();
  }
}