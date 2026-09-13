# Birthday Page

A soft birthday scene with separately animated cake, candle, flame, smoke and confetti assets.

```dart
import 'package:birthday_page/birthday_page.dart';

BirthdayCelebrationPage(
  name: '伟伟',
  onCelebrated: () { /* Wish completed, once per candle. */ },
  onSkip: () { /* Optional navigation. */ },
)
```

Run the app in `example` with `flutter run`. Tap **Let’s Celebrate**, grant microphone access, stay quiet for 600 ms, then blow steadily for about 500 ms. A manual alternative works without microphone access. Tap the main button after celebration to try again.

Audio uses the [record plugin](https://pub.dev/packages/record) as mono PCM16 at 16 kHz. Analysis stays in memory; no recording is saved or uploaded. The detector uses an environmental median + 15 dB threshold, sustained level, zero-crossing rate and level stability. It is a heuristic: steady fans or unvoiced speech may trigger it, and device microphone processing may affect sensitivity. Validate and tune on your target phones.

Flame extinction lasts 750 ms; smoke fades over 2.2 s; restrained confetti begins 300 ms after extinction. Listening stops on backgrounding, disposal, completion, errors or after 30 seconds.

## Host app setup

- Android: microphone permission is merged from this plugin; record requires Android API 24 or later (resolved record_android 2.2.0).
- iOS/macOS: add `NSMicrophoneUsageDescription` to the host Info.plist. For sandboxed macOS, enable `com.apple.security.device.audio-input`. The example includes these entries.
- Web: microphone access requires HTTPS or localhost and browser permission.
- Linux: install record's documented native dependencies (`parecord`, `pactl`, `ffmpeg`).

## Assets

Existing assets are used without modification:

- `25da44db-…png`: cake and plate
- `986f8b8c-…png`: unlit candle
- `5b6d5dba-…png`: flame
- `bc41684c-…png`: smoke
- `079a093e-…png`: background confetti

Layer placement accounts for transparent padding in the original files. The supplied SVG alternatives are retained. The heading currently uses a platform serif italic fallback; the exact handwritten font in the reference was not supplied.

## Validation

Run `flutter analyze`, `flutter test`, and `flutter test` in `example`. Detector tests cover sustained noise, interrupted bursts and arbitrary byte chunk boundaries. Widget tests cover manual completion and small-screen layout. Real microphone behavior still needs a physical-device check.

