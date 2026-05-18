import 'package:anime_deduction_tower/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app renders splash flow shell', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Anime Deduction Tower'), findsWidgets);
  });
}
