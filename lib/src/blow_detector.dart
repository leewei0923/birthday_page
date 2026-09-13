import 'dart:math' as math;
import 'dart:typed_data';

/// Fixed 20 ms PCM16 frames make detection independent of stream chunk size.
class BlowDetector {
  final List<int> _bytes = [];
  final List<double> _baseline = [];
  final List<double> _levels = [];
  double threshold = -37;
  double strength = 0;
  bool blown = false;
  bool get calibrated => _baseline.length >= 30;

  void add(Uint8List bytes) {
    if (blown) return;
    _bytes.addAll(bytes);
    while (_bytes.length >= 640 && !blown) {
      final frame = ByteData.sublistView(
        Uint8List.fromList(_bytes.sublist(0, 640)),
      );
      _bytes.removeRange(0, 640);
      double energy = 0, peak = 0, previous = 0;
      int crossings = 0;
      for (int i = 0; i < 320; i++) {
        final value = frame.getInt16(i * 2, Endian.little) / 32768;
        energy += value * value;
        peak = math.max(peak, value.abs());
        if (i > 0 && (value >= 0) != (previous >= 0)) crossings++;
        previous = value;
      }
      final rms = math.sqrt(energy / 320);
      final db = 20 * math.log(math.max(rms, 0.00001)) / math.ln10;
      if (!calibrated) {
        _baseline.add(db);
        if (calibrated) {
          final sorted = [..._baseline]..sort();
          threshold = (sorted[15] + 15).clamp(-55, -12);
        }
        continue;
      }
      final target = ((db - threshold + 6) / 22).clamp(0.0, 1.0);
      strength += (target - strength) * 0.35;
      // Reject brief impulses and low-crossing voiced sounds; require 500 ms
      // of continuous noise with a standard deviation below 5 dB.
      if (db > threshold &&
          crossings / 320 > 0.055 &&
          peak / math.max(rms, 0.00001) < 7) {
        _levels.add(db);
        if (_levels.length > 25) _levels.removeAt(0);
        if (_levels.length == 25) {
          final mean = _levels.reduce((a, b) => a + b) / 25;
          final variance =
              _levels.fold<double>(0, (sum, x) => sum + math.pow(x - mean, 2)) /
              25;
          blown = variance < 25;
        }
      } else {
        _levels.clear();
      }
    }
  }
}
