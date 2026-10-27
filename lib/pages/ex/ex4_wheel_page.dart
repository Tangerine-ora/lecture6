import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../widgets/lab_widgets.dart';

/// 6A · EX4 抽奖转盘修复版。
/// 病根：① 盘面是旋转对称的渐变，转了看不出变化；② 六颗星 Positioned(20,20) 全叠在一处；
/// ③ 结果用 DateTime.now().millisecond % 6，和最终角度无关。
/// 修复：六个扇区换色并让文字随盘转动；星星按圆周坐标分布；结果由最终角度反推扇区。
class Ex4WheelPage extends StatefulWidget {
  const Ex4WheelPage({super.key});

  @override
  State<Ex4WheelPage> createState() => _Ex4WheelPageState();
}

class _Ex4WheelPageState extends State<Ex4WheelPage>
    with SingleTickerProviderStateMixin {
  static const _prizes = ['谢谢参与', '50 积分', '10 元券', '再来一次', 'iPhone 18', '神秘大奖'];
  static const _colors = [
    Color(0xFFF87171),
    Color(0xFFFBBF24),
    Color(0xFF34D399),
    Color(0xFF60A5FA),
    Color(0xFFA78BFA),
    Color(0xFFF472B6),
  ];
  static const _sweep = 2 * math.pi / 6;

  final _random = math.Random(6);
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  double _rotation = 0;
  double _from = 0;
  double _to = 0;
  int _pendingWinner = 0;
  String? _result;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _rotation = _to;
          _spinning = false;
          _result = _prizes[_pendingWinner];
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_spinning) return;
    final winner = _random.nextInt(_prizes.length);
    final turns = 4 + _random.nextInt(3);
    // 指针在 12 点方向：让第 winner 个扇区的中心最终停在 0°。
    var target = 2 * math.pi * turns - (winner + 0.5) * _sweep;
    while (target < _rotation + 2 * math.pi * 3) {
      target += 2 * math.pi;
    }

    setState(() {
      _pendingWinner = winner;
      _from = _rotation;
      _to = target;
      _result = null;
      _spinning = true;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'EX4 抽奖转盘 · 修复版',
      intro:
          '病根：渐变盘旋转对称看不出在转、星星全叠在一处、结果与盘面无关。'
          '修复后六个彩色扇区与文字一起转，星星按圆周分布，停下时指针指向的扇区就是中奖结果。',
      children: [
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = math.min(constraints.maxWidth, 300.0);
              return SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final t =
                            Curves.easeOutCubic.transform(_controller.value);
                        final angle = _from + (_to - _from) * t;
                        return Transform.rotate(angle: angle, child: child);
                      },
                      child: CustomPaint(
                        size: Size.square(size),
                        painter: _WheelPainter(
                          prizes: _prizes,
                          colors: _colors,
                        ),
                      ),
                    ),
                    // 中心按钮
                    ElevatedButton(
                      onPressed: _spin,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF111827),
                        minimumSize: const Size(88, 88),
                        elevation: 4,
                      ),
                      child: Text(
                        _spinning ? '转动中' : '开始\n抽奖',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),
                    // 顶部指针
                    Positioned(
                      top: -2,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 46,
                        color: _spinning ? Colors.black38 : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            _result == null
                ? (_spinning ? '转盘旋转中……' : '点中间按钮开始抽奖')
                : '结果：$_result',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _result == null ? kTextSub : const Color(0xFFEF4444),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '结果不是随机数直接给的：先定目标扇区，再反算总旋转角，'
          '所以指针停下时一定落在结果对应的扇区。',
          style: TextStyle(fontSize: 11.5, height: 1.55, color: kTextSub),
        ),
      ],
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.prizes, required this.colors});

  final List<String> prizes;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final sweep = 2 * math.pi / prizes.length;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var i = 0; i < prizes.length; i++) {
      final start = -math.pi / 2 + i * sweep;
      canvas.drawArc(
        rect,
        start,
        sweep,
        true,
        Paint()..color = colors[i % colors.length],
      );
      // 分隔线
      canvas.drawLine(
        center,
        center +
            Offset(math.cos(start) * radius, math.sin(start) * radius),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2,
      );
      // 文字随盘转动
      final mid = start + sweep / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i],
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
      )..layout(maxWidth: radius * 0.34);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(mid);
      // 起点放在 0.40R，避开中心的按钮；文字沿半径向外排。
      textPainter.paint(
        canvas,
        Offset(radius * 0.40, -textPainter.height / 2),
      );
      canvas.restore();

      // 星星标记：按圆周角度分别定位，不再叠在同一处
      final star = TextPainter(
        text: const TextSpan(
          text: '★',
          style: TextStyle(fontSize: 11, color: Colors.white70),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final starCenter =
          center + Offset(math.cos(mid), math.sin(mid)) * (radius * 0.84);
      star.paint(
        canvas,
        starCenter - Offset(star.width / 2, star.height / 2),
      );
    }

    // 外圈
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}
