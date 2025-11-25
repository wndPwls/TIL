import 'package:flutter_test/flutter_test.dart';
import 'package:dice_game/main.dart';

void main() {
  testWidgets('Dice App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiceApp());

    // Verify that the title is present.
    expect(find.text('LUCKY DICE'), findsOneWidget);
  });
}
