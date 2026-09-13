import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:birthday_page/birthday_page.dart';

void main() {
  testWidgets(
    'manual wish completes once without microphone and fits a small screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      int completed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: BirthdayCelebrationPage(onCelebrated: () => completed++),
        ),
      );
      expect(find.text('Birthday!'), findsOneWidget);
      await tester.tap(find.text('也可以轻点这里，吹灭蜡烛'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.text('Happy Birthday, 伟伟'), findsOneWidget);
      expect(completed, 1);
      await tester.pump(const Duration(seconds: 7));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
