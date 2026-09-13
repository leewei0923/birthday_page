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
      expect(find.text('生日快乐，伟伟'), findsOneWidget);
      expect(completed, 1);
      await tester.pump(const Duration(seconds: 7));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('supports English and customized copy', (tester) async {
    tester.view.physicalSize = const Size(800, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final texts = BirthdayCelebrationTexts.en.copyWith(
      birthdayGreeting: 'Have a wonderful birthday, {name}!',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BirthdayCelebrationPage(name: 'Alex', texts: texts),
      ),
    );

    expect(find.text('Let’s Celebrate  →'), findsOneWidget);
    expect(find.text('Or tap here to blow out the candle'), findsOneWidget);
    await tester.tap(find.text('Or tap here to blow out the candle'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Have a wonderful birthday, Alex!'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('supports custom body and birthday title fonts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BirthdayCelebrationPage(
          fontFamily: 'HostSans',
          birthdayFontFamily: 'HostScript',
        ),
      ),
    );

    final heading = tester.widget<Text>(find.text('H A P P Y'));
    final title = tester.widget<Text>(find.text('Birthday!'));
    final startButton = tester.widget<Text>(find.text('开始庆祝  →'));
    expect(heading.style?.fontFamily, 'HostSans');
    expect(title.style?.fontFamily, 'HostScript');
    expect(startButton.style?.fontFamily, 'HostSans');
  });
}
