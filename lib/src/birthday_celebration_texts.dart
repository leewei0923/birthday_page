import 'package:flutter/widgets.dart';

/// User-facing copy used by the birthday celebration page.
///
/// Use one of the built-in language presets, select one with [forLocale], or
/// create a custom instance for the host application's tone of voice.
@immutable
class BirthdayCelebrationTexts {
  const BirthdayCelebrationTexts({
    required this.happyHeading,
    required this.birthdayTitle,
    required this.wishMessage,
    required this.skipButton,
    required this.initialHint,
    required this.openingMicrophoneHint,
    required this.calibratingHint,
    required this.blowHint,
    required this.microphoneUnavailableHint,
    required this.timeoutHint,
    required this.resumeHint,
    required this.pausedHint,
    required this.extinguishingHint,
    required this.birthdayGreeting,
    required this.startButton,
    required this.listeningButton,
    required this.retryButton,
    required this.manualExtinguishButton,
    required this.completedMessage,
  });

  /// Simplified Chinese copy. The decorative birthday headings remain English.
  static const zhHans = BirthdayCelebrationTexts(
    happyHeading: 'H A P P Y',
    birthdayTitle: 'Birthday!',
    wishMessage: '愿你的这一天充满幸福，\n也拥有所有值得的美好。',
    skipButton: '跳过',
    initialHint: '点亮这一刻，许一个小小的愿望',
    openingMicrophoneHint: '正在开启麦克风…',
    calibratingHint: '先安静一小会儿，听听周围的声音…',
    blowHint: '对着麦克风轻轻吹气，持续半秒',
    microphoneUnavailableHint: '麦克风暂不可用，也可以点下方手动吹灭',
    timeoutHint: '休息一下吧，点按钮可以重新尝试',
    resumeHint: '回来啦，点击按钮继续许愿',
    pausedHint: '已暂停，准备好再继续',
    extinguishingHint: '把愿望藏在心里…',
    birthdayGreeting: '生日快乐，{name}',
    startButton: '开始庆祝  →',
    listeningButton: '正在聆听  ·  点击暂停',
    retryButton: '愿望会实现的  ✦  再许一次',
    manualExtinguishButton: '也可以轻点这里，吹灭蜡烛',
    completedMessage: '愿你每一天都被温柔以待',
  );

  /// English copy.
  static const en = BirthdayCelebrationTexts(
    happyHeading: 'H A P P Y',
    birthdayTitle: 'Birthday!',
    wishMessage:
        'Wishing you a day filled with\nhappiness and all the good things\nyou deserve.',
    skipButton: 'Skip',
    initialHint: 'Light the moment and make a wish',
    openingMicrophoneHint: 'Turning on the microphone…',
    calibratingHint: 'Stay quiet for a moment while we listen…',
    blowHint: 'Blow gently toward the microphone for half a second',
    microphoneUnavailableHint:
        'The microphone is unavailable. You can extinguish it manually below.',
    timeoutHint: 'Take a break, then tap the button to try again',
    resumeHint: 'Welcome back. Tap the button to continue',
    pausedHint: 'Paused. Continue whenever you are ready',
    extinguishingHint: 'Keep your wish close…',
    birthdayGreeting: 'Happy Birthday, {name}',
    startButton: 'Let’s Celebrate  →',
    listeningButton: 'Listening  ·  Tap to pause',
    retryButton: 'Make Another Wish  ✦',
    manualExtinguishButton: 'Or tap here to blow out the candle',
    completedMessage: 'May every day be kind to you',
  );

  /// Returns Chinese for Chinese locales and English for all other locales.
  static BirthdayCelebrationTexts forLocale(Locale locale) =>
      locale.languageCode.toLowerCase() == 'zh' ? zhHans : en;

  final String happyHeading;
  final String birthdayTitle;
  final String wishMessage;
  final String skipButton;
  final String initialHint;
  final String openingMicrophoneHint;
  final String calibratingHint;
  final String blowHint;
  final String microphoneUnavailableHint;
  final String timeoutHint;
  final String resumeHint;
  final String pausedHint;
  final String extinguishingHint;

  /// Birthday greeting containing an optional `{name}` placeholder.
  final String birthdayGreeting;

  final String startButton;
  final String listeningButton;
  final String retryButton;
  final String manualExtinguishButton;
  final String completedMessage;

  String greetingFor(String name) =>
      birthdayGreeting.replaceAll('{name}', name);

  BirthdayCelebrationTexts copyWith({
    String? happyHeading,
    String? birthdayTitle,
    String? wishMessage,
    String? skipButton,
    String? initialHint,
    String? openingMicrophoneHint,
    String? calibratingHint,
    String? blowHint,
    String? microphoneUnavailableHint,
    String? timeoutHint,
    String? resumeHint,
    String? pausedHint,
    String? extinguishingHint,
    String? birthdayGreeting,
    String? startButton,
    String? listeningButton,
    String? retryButton,
    String? manualExtinguishButton,
    String? completedMessage,
  }) => BirthdayCelebrationTexts(
    happyHeading: happyHeading ?? this.happyHeading,
    birthdayTitle: birthdayTitle ?? this.birthdayTitle,
    wishMessage: wishMessage ?? this.wishMessage,
    skipButton: skipButton ?? this.skipButton,
    initialHint: initialHint ?? this.initialHint,
    openingMicrophoneHint: openingMicrophoneHint ?? this.openingMicrophoneHint,
    calibratingHint: calibratingHint ?? this.calibratingHint,
    blowHint: blowHint ?? this.blowHint,
    microphoneUnavailableHint:
        microphoneUnavailableHint ?? this.microphoneUnavailableHint,
    timeoutHint: timeoutHint ?? this.timeoutHint,
    resumeHint: resumeHint ?? this.resumeHint,
    pausedHint: pausedHint ?? this.pausedHint,
    extinguishingHint: extinguishingHint ?? this.extinguishingHint,
    birthdayGreeting: birthdayGreeting ?? this.birthdayGreeting,
    startButton: startButton ?? this.startButton,
    listeningButton: listeningButton ?? this.listeningButton,
    retryButton: retryButton ?? this.retryButton,
    manualExtinguishButton:
        manualExtinguishButton ?? this.manualExtinguishButton,
    completedMessage: completedMessage ?? this.completedMessage,
  );
}
