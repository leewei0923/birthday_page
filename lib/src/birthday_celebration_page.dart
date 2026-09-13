import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'blow_detector.dart';

enum CandleState { idle, blowing, extinguishing, extinguished }

/// Birthday scene with in-memory microphone analysis; no audio files are saved.
class BirthdayCelebrationPage extends StatefulWidget {
  const BirthdayCelebrationPage({
    super.key,
    this.name = '伟伟',
    this.onSkip,
    this.onCelebrated,
  });
  final String name;
  final VoidCallback? onSkip;
  final VoidCallback? onCelebrated;
  @override
  State<BirthdayCelebrationPage> createState() =>
      _BirthdayCelebrationPageState();
}

class _BirthdayCelebrationPageState extends State<BirthdayCelebrationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final _flicker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 17),
  )..repeat();
  late final _out = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );
  late final _celebrate = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );
  AudioRecorder? _recorder;
  StreamSubscription<Uint8List>? _audio;
  Timer? _timeout;
  BlowDetector _detector = BlowDetector();
  CandleState _state = CandleState.idle;
  bool _starting = false, _listening = false;
  int _session = 0;
  String _hint = '点亮这一刻，许一个小小的愿望';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _stop() async {
    _session++;
    _timeout?.cancel();
    final audio = _audio;
    final recorder = _recorder;
    _audio = null;
    _recorder = null;
    _listening = false;
    _starting = false;
    await audio?.cancel();
    if (recorder != null) {
      try {
        await recorder.stop();
      } catch (_) {
        /* Already stopped. */
      }
      try {
        await recorder.dispose();
      } catch (_) {
        /* Device disconnected. */
      }
    }
  }

  Future<void> _listen() async {
    if (_starting || _listening || _state == CandleState.extinguishing) return;
    if (_state == CandleState.extinguished) {
      _out.reset();
      _celebrate.reset();
      setState(() => _state = CandleState.idle);
    }
    final session = ++_session;
    setState(() {
      _starting = true;
      _hint = '正在开启麦克风…';
    });
    final recorder = AudioRecorder();
    _recorder = recorder;
    try {
      final permitted = await recorder.hasPermission();
      if (!mounted || session != _session) return;
      if (!permitted) throw StateError('Microphone permission denied');
      final stream = await recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
          autoGain: false,
          echoCancel: false,
          noiseSuppress: false,
        ),
      );
      if (!mounted || session != _session) return;
      _detector = BlowDetector();
      setState(() {
        _starting = false;
        _listening = true;
        _hint = '先安静一小会儿，听听周围的声音…';
      });
      _audio = stream.listen(
        (bytes) {
          if (!mounted || session != _session) return;
          _detector.add(bytes);
          if (_detector.blown) {
            unawaited(_extinguish());
            return;
          }
          setState(() {
            _state = _detector.strength > 0.15
                ? CandleState.blowing
                : CandleState.idle;
            _hint = _detector.calibrated
                ? '对着麦克风轻轻吹气，持续半秒'
                : '先安静一小会儿，听听周围的声音…';
          });
        },
        onError: (Object error) {
          if (session == _session) _unavailable();
        },
        onDone: () {
          if (mounted && session == _session) _unavailable();
        },
      );
      _timeout = Timer(
        const Duration(seconds: 30),
        () => _unavailable('休息一下吧，点按钮可以重新尝试'),
      );
    } catch (_) {
      if (mounted && session == _session) _unavailable();
    }
  }

  void _unavailable([String message = '麦克风暂不可用，也可以点下方手动吹灭']) {
    unawaited(_stop());
    if (mounted) {
      setState(() {
        _state = CandleState.idle;
        _hint = message;
      });
    }
  }

  Future<void> _extinguish() async {
    if (_state == CandleState.extinguishing ||
        _state == CandleState.extinguished) {
      return;
    }
    unawaited(_stop());
    setState(() {
      _state = CandleState.extinguishing;
      _hint = '把愿望藏在心里…';
    });
    await _out.forward(from: 0).orCancel.catchError((Object _) {});
    if (!mounted) return;
    setState(() {
      _state = CandleState.extinguished;
      _hint = 'Happy Birthday, ${widget.name}';
    });
    _celebrate.forward(from: 0);
    widget.onCelebrated?.call();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && (_listening || _starting)) {
      _unavailable('回来啦，点击按钮继续许愿');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_stop());
    _flicker.dispose();
    _out.dispose();
    _celebrate.dispose();
    super.dispose();
  }

  Widget _asset(String file) => Image.asset(
    'assets/$file.png',
    package: 'birthday_page',
    fit: BoxFit.fill,
    excludeFromSemantics: true,
  );

  @override
  Widget build(BuildContext context) {
    final done = _state == CandleState.extinguished;
    return Scaffold(
      backgroundColor: const Color(0xfffaf8f5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: math.min(constraints.maxWidth, 520),
                  height: math.max(constraints.maxHeight, 760),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_flicker, _out, _celebrate]),
                    builder: (context, _) {
                      final t = _flicker.value * math.pi * 2;
                      final breath = _listening ? _detector.strength : 0.0;
                      final out = _out.value;
                      final shrink = 1 - ((out - 0.68) / 0.32).clamp(0.0, 1.0);
                      final angle =
                          math.sin(t * 23) * 0.025 +
                          math.sin(t * 41) * 0.02 -
                          breath * 0.5 -
                          out * 0.45 +
                          math.sin(out * 65) * out * 0.13;
                      final seconds = _celebrate.value * 6;
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Opacity(
                                opacity: 0.22,
                                child: _asset(
                                  '079a093e-e16d-4b1a-a0dc-ed7b0b0a7568',
                                ),
                              ),
                            ),
                          ),
                          if (widget.onSkip != null)
                            Positioned(
                              right: 20,
                              top: 8,
                              child: TextButton(
                                onPressed: () {
                                  unawaited(_stop());
                                  widget.onSkip?.call();
                                },
                                child: const Text('Skip'),
                              ),
                            ),
                          Positioned(
                            top: 70,
                            left: 12,
                            right: 12,
                            child: Transform.scale(
                              scale:
                                  1 +
                                  (seconds > 0.3 && seconds < 1.3
                                      ? math.sin((seconds - 0.3) * math.pi) *
                                            0.025
                                      : 0),
                              child: const Column(
                                children: [
                                  Text(
                                    'H A P P Y',
                                    style: TextStyle(
                                      fontSize: 22,
                                      letterSpacing: 9,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  FittedBox(
                                    child: Text(
                                      'Birthday!',
                                      style: TextStyle(
                                        fontFamily: 'Georgia',
                                        fontStyle: FontStyle.italic,
                                        fontSize: 66,
                                        height: 1.2,
                                        color: Color(0xff2d2b29),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Wishing you a day filled with\nhappiness and all the good things\nyou deserve.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Color(0xff85817b),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 156,
                            height: 280,
                            child: FittedBox(
                              child: SizedBox(
                                width: 360,
                                height: 280,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 55,
                                      top: 225,
                                      width: 250,
                                      height: 14,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x22000000),
                                              blurRadius: 22,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      width: 360,
                                      height: 300,
                                      child: _asset(
                                        '25da44db-e681-4c59-80fe-961e3d495e3a',
                                      ),
                                    ),
                                    // Asset padding places the wick at 50% x / 10% y.
                                    Positioned(
                                      left: 160,
                                      top: 4,
                                      width: 40,
                                      height: 120,
                                      child: _asset(
                                        '986f8b8c-25f9-4d60-8e3c-1723dfcbb4f4',
                                      ),
                                    ),
                                    if (!done)
                                      Positioned(
                                        left: 162,
                                        top: -46,
                                        width: 36,
                                        height: 90,
                                        child: Transform(
                                          alignment: const Alignment(0, 0.42),
                                          transform: Matrix4.identity()
                                            ..rotateZ(angle)
                                            ..scaleByDouble(
                                              shrink * (1 - breath * 0.18),
                                              shrink *
                                                  (1 +
                                                      breath * 0.2 +
                                                      math.sin(t * 31) * 0.045),
                                              1,
                                              1,
                                            ),
                                          child: Opacity(
                                            opacity: shrink,
                                            child: _asset(
                                              '5b6d5dba-10c7-42c4-b2f8-924ea114d4f4',
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (done && seconds < 2.2)
                                      Positioned(
                                        left: 158 + math.sin(seconds * 3) * 3,
                                        top: -63 - seconds * 16,
                                        width: 44,
                                        height: 100,
                                        child: Opacity(
                                          opacity:
                                              (math.sin(
                                                        seconds / 2.2 * math.pi,
                                                      ) *
                                                      0.35)
                                                  .clamp(0.0, 0.35),
                                          child: _asset(
                                            'bc41684c-bfab-492f-9533-aa94e21aee96',
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (done)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: _ConfettiPainter(seconds),
                                ),
                              ),
                            ),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            child: Column(
                              children: [
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    _hint,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xff898177),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: 280,
                                  height: 54,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xff30302e),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed:
                                        _starting ||
                                            _state == CandleState.extinguishing
                                        ? null
                                        : (_listening
                                              ? () => _unavailable('已暂停，准备好再继续')
                                              : _listen),
                                    child: Text(
                                      done
                                          ? '愿望会实现的  ✦  再许一次'
                                          : _listening
                                          ? '正在聆听  ·  点击暂停'
                                          : 'Let’s Celebrate  →',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed:
                                      done ||
                                          _state == CandleState.extinguishing
                                      ? null
                                      : _extinguish,
                                  child: Text(
                                    done ? '愿你每一天都被温柔以待' : '也可以轻点这里，吹灭蜡烛',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff9b9185),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.seconds);
  final double seconds;
  @override
  void paint(Canvas canvas, Size size) {
    if (seconds < 0.3) return;
    final random = math.Random(24);
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final delay = random.nextDouble() * 1.4;
      final speed = 70 + random.nextDouble() * 55;
      final elapsed = seconds - 0.3 - delay;
      if (elapsed < 0) continue;
      final opacity = ((6 - seconds) / 1.2).clamp(0.0, 0.7);
      canvas.save();
      canvas.translate(
        x + math.sin(elapsed * 1.5 + i) * 20,
        -20 + elapsed * speed,
      );
      canvas.rotate(elapsed + i);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: 7.0 + i % 5,
          height: 4 + math.sin(elapsed * 3 + i).abs() * 4,
        ),
        Paint()
          ..color =
              (i.isEven ? const Color(0xffd2ac65) : const Color(0xffedc5b6))
                  .withValues(alpha: opacity),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      seconds != oldDelegate.seconds;
}
