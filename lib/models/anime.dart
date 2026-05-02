class Anime {
  final int malId;
  final String title;
  final String? imageUrl;
  final int? episodes;
  final String? synopsis;
  final String? rating;
  final num? score;

  Anime({
    required this.malId,
    required this.title,
    this.imageUrl,
    this.episodes,
    this.synopsis,
    this.rating,
    this.score,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;

    return Anime(
      malId: json['mal_id'] as int,
      title: json['title'] as String? ?? 'Unknown Title',
      imageUrl: images?['jpg']?['image_url'] as String?,
      episodes: json['episodes'] as int?,
      synopsis: json['synopsis'] as String?,
      rating: json['rating'] as String?,
      score: (json['score'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'image_url': imageUrl,
      'episodes': episodes,
      'synopsis': synopsis,
      'rating': rating,
      'score': score,
    };
  }
}