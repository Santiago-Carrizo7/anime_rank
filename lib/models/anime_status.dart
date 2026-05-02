enum AnimeStatus {
  watched,
  toWatch,
  dropped;

  String get displayName {
    switch (this) {
      case AnimeStatus.watched:
        return 'Watched';
      case AnimeStatus.toWatch:
        return 'To Watch';
      case AnimeStatus.dropped:
        return 'Dropped';
    }
  }

  String get dbValue {
    switch (this) {
      case AnimeStatus.watched:
        return 'watched';
      case AnimeStatus.toWatch:
        return 'to_watch';
      case AnimeStatus.dropped:
        return 'dropped';
    }
  }

  static AnimeStatus fromDbValue(String value) {
    switch (value) {
      case 'watched':
        return AnimeStatus.watched;
      case 'to_watch':
        return AnimeStatus.toWatch;
      case 'dropped':
        return AnimeStatus.dropped;
      default:
        return AnimeStatus.toWatch;
    }
  }
}