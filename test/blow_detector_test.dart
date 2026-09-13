import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:birthday_page/src/blow_detector.dart';

Uint8List noise(int frames, double amplitude) {
  final random = Random(41);
  final data = ByteData(frames * 640);
  for (int i = 0; i < frames * 320; i++) {
    data.setInt16(
      i * 2,
      ((random.nextDouble() * 2 - 1) * amplitude * 32767).round(),
      Endian.little,
    );
  }
  return data.buffer.asUint8List();
}

void main() {
  test('calibrates then requires half a second of steady noise', () {
    final detector = BlowDetector()..add(noise(30, 0.005));
    expect(detector.calibrated, isTrue);
    detector.add(noise(24, 0.15));
    expect(detector.blown, isFalse);
    detector.add(noise(1, 0.15));
    expect(detector.blown, isTrue);
  });
  test('rejects silence, impulses and interrupted speech-like bursts', () {
    final detector = BlowDetector()..add(noise(30, 0.005));
    for (int i = 0; i < 10; i++) {
      detector.add(noise(8, 0.15));
      detector.add(noise(3, 0.005));
    }
    expect(detector.blown, isFalse);
  });
  test('odd byte chunks preserve PCM framing', () {
    final detector = BlowDetector();
    final bytes = Uint8List.fromList([...noise(30, 0.005), ...noise(25, 0.15)]);
    for (int i = 0; i < bytes.length; i += 117) {
      detector.add(Uint8List.sublistView(bytes, i, min(i + 117, bytes.length)));
    }
    expect(detector.blown, isTrue);
  });
}
