import 'package:flutter_test/flutter_test.dart';
import 'package:birthday_page_example/main.dart';

void main() {
  testWidgets('shows the birthday scene', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Birthday!'), findsOneWidget);
    expect(find.text('Let’s Celebrate  →'), findsOneWidget);
  });
}
