import 'anime_status.dart';

class TrackedAnime {
  final int? id;
  final int malId;
  final String title;
  final String? imageUrl;
  final int? episodes;
  final AnimeStatus status;
  final DateTime dateAdded;
  final int? sortOrder;

  TrackedAnime({
    this.id,
    required this.malId,
    required this.title,
    this.imageUrl,
    this.episodes,
    required this.status,
    required this.dateAdded,
    this.sortOrder,
  });

  factory TrackedAnime.fromMap(Map<String, dynamic> map) {
    return TrackedAnime(
      id: map['id'] as int?,
      malId: map['mal_id'] as int,
      title: map['title'] as String,
      imageUrl: map['image_url'] as String?,
      episodes: map['episodes'] as int?,
      status: AnimeStatus.fromDbValue(map['status'] as String),
      dateAdded: DateTime.parse(map['date_added'] as String),
      sortOrder: map['sort_order'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mal_id': malId,
      'title': title,
      'image_url': imageUrl,
      'episodes': episodes,
      'status': status.dbValue,
      'date_added': dateAdded.toIso8601String(),
      'sort_order': sortOrder,
    };
  }

  TrackedAnime copyWith({
    int? id,
    int? malId,
    String? title,
    String? imageUrl,
    int? episodes,
    AnimeStatus? status,
    DateTime? dateAdded,
    int? sortOrder,
  }) {
    return TrackedAnime(
      id: id ?? this.id,
      malId: malId ?? this.malId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      episodes: episodes ?? this.episodes,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}