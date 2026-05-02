import 'package:flutter_test/flutter_test.dart';
import 'package:anime_rank/main.dart';

void main() {
  testWidgets('AnimeRank app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AnimeRankApp());
    await tester.pumpAndSettle();

    expect(find.text('Search Anime'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('My List'), findsOneWidget);
  });
}