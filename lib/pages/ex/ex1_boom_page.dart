import 'dart:math';

import 'package:flutter/material.dart';

import '../../widgets/lab_widgets.dart';

/// 6A · EX1 热区彩蛋修复版。
/// 病根：原实现只有「点中 → 弹一个 ! 圆圈」的两态逻辑，没有粒子列表与动画，也没有金币奖励。
/// 修复：点击后生成一批粒子并按动画向外飞散，同时给出随机奖励图标与金币计数。
class Ex1BoomPage extends StatefulWidget {
  const Ex1BoomPage({super.key});

  @override
  State<Ex1BoomPage> createState() => _Ex1BoomPageState();
}

class _Ex1BoomPageState extends State<Ex1BoomPage>
    with SingleTickerProviderStateMixin {
  static const _rewards = [
    _Reward('金币', Icons.monetization_on, 3, Color(0xFFF59E0B)),
    _Reward('宝石', Icons.diamond, 5, Color(0xFF06B6D4)),
    _Reward('星星', Icons.auto_awesome, 2, Color(0xFF8B5CF6)),
    _Reward('没有奖励', Icons.sentiment_dissatisfied, 0, Color(0xFF9CA3AF)),
  ];

  static const _icons = [
    _PosIcon(top: 24, left: 32, icon: Icons.star, color: Colors.amber),
    _PosIcon(top: 60, left: 176, icon: Icons.favorite, color: Colors.redAccent),
    _PosIcon(top: 128, left: 84, icon: Icons.bolt, color: Colors.orange),
    _PosIcon(top: 96, left: 252, icon: Icons.water_drop, color: Colors.blue),
    _PosIcon(top: 188, left: 156, icon: Icons.auto_awesome, color: Colors.purpleAccent),
  ];

  final _random = Random(6);
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  );

  Offset? _origin;
  List<_Particle> _particles = const [];
  _Reward? _reward;
  int _coins = 0;
  int _hits = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hit(_PosIcon source) {
    final particles = List.generate(14, (i) {
      final angle = 2 * pi * i / 14 + (_random.nextDouble() - 0.5) * 0.35;
      return _Particle(
        angle: angle,
        speed: 55 + _random.nextDouble() * 75,
        color: source.color,
        size: 5 + _random.nextDouble() * 6,
      );
    });
    final reward = _rewards[_random.nextInt(_rewards.length)];

    setState(() {
      _origin = Offset(source.left + 18, source.top + 18);
      _particles = particles;
      _reward = reward;
      _coins += reward.coins;
      _hits++;
    });
    _controller.forward(from: 0);
  }

  void _reset() {
    _controller.stop();
    setState(() {
      _origin = null;
      _particles = const [];
      _reward = null;
      _coins = 0;
      _hits = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'EX1 热区彩蛋 · 修复版',
      intro:
          '病根：只有 _hitIcon 两态切换，缺粒子列表与动画。修复后点击图标会从图标中心炸出 14 颗粒子，'
          '并按概率掉落金币 / 宝石 / 星星奖励，右下角累计金币。',
      children: [
        const SectionHeader('爆炸区域', param: 'Stack + AnimatedBuilder'),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1FB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDDE3F7)),
          ),
          child: Stack(
            children: [
              for (final p in _icons)
                Positioned(
                  top: p.top,
                  left: p.left,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _hit(p),
                    child: Icon(p.icon, color: p.color, size: 36),
                  ),
                ),
              if (_origin != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final t = Curves.easeOutCubic.transform(_controller.value);
                        return Stack(
                          children: [
                            for (final p in _particles)
                              Positioned(
                                left: _origin!.dx +
                                    cos(p.angle) * p.speed * t -
                                    p.size / 2,
                                top: _origin!.dy +
                                    sin(p.angle) * p.speed * t -
                                    p.size / 2,
                                child: Opacity(
                                  opacity: (1 - _controller.value).clamp(0.0, 1.0),
                                  child: Container(
                                    width: p.size * (1 - t * 0.4),
                                    height: p.size * (1 - t * 0.4),
                                    decoration: BoxDecoration(
                                      color: p.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            if (_reward != null)
                              Center(
                                child: Opacity(
                                  opacity: (1 - _controller.value).clamp(0.0, 1.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _reward!.icon,
                                        size: 46,
                                        color: _reward!.color,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _reward!.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: _reward!.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 15,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_coins',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                _hits == 0
                    ? '点一个图标试试，彩蛋藏在里面'
                    : '已点 $_hits 次，最近奖励：${_reward?.name ?? '-'}',
                style: const TextStyle(fontSize: 12, color: kTextSub),
              ),
            ),
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('重置'),
            ),
          ],
        ),
      ],
    );
  }
}

class _PosIcon {
  const _PosIcon({
    required this.top,
    required this.left,
    required this.icon,
    required this.color,
  });

  final double top;
  final double left;
  final IconData icon;
  final Color color;
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
  });

  final double angle;
  final double speed;
  final Color color;
  final double size;
}

class _Reward {
  const _Reward(this.name, this.icon, this.coins, this.color);

  final String name;
  final IconData icon;
  final int coins;
  final Color color;
}
