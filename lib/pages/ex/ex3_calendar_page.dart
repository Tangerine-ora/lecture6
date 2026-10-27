import 'package:flutter/material.dart';

import '../../widgets/lab_widgets.dart';

/// 6A · EX3 打卡日历修复版。
/// 病根：格子宽度用 MediaQuery 全屏宽 / 7 计算，宽屏时每格被无限拉宽，不是整齐的 7 列。
/// 修复：格子固定 40×40，Wrap 间距 6，外层 ConstrainedBox 限宽 360，永远 7 列。
class Ex3CalendarPage extends StatefulWidget {
  const Ex3CalendarPage({super.key});

  @override
  State<Ex3CalendarPage> createState() => _Ex3CalendarPageState();
}

class _Ex3CalendarPageState extends State<Ex3CalendarPage> {
  static const _cellSize = 40.0;
  static const _gap = 6.0;
  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  final List<bool> _checked = List.generate(31, (_) => false);

  int get _checkedCount => _checked.where((e) => e).length;

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'EX3 打卡日历 · 修复版',
      intro:
          '病根：格子宽度 = (屏幕宽 - 固定值) / 7，屏幕越宽格子越宽，7 列被拉变形。'
          '修复：格子固定 40 宽，Wrap 每行 7 个（40×7 + 6×6 = 316），外层限宽 360。'
          '把浏览器拉宽拉窄都保持整齐。',
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                '2026 年 10 月 · 31 天',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '已打卡 $_checkedCount 天',
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Row(
                    spacing: _gap,
                    children: [
                      for (final w in _weekdays)
                        SizedBox(
                          width: _cellSize,
                          child: Text(
                            w,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: kTextSub,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: _gap,
                    runSpacing: _gap,
                    children: [
                      for (var i = 0; i < 31; i++)
                        SizedBox(
                          width: _cellSize,
                          height: _cellSize,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _checked[i] = !_checked[i]),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _checked[i]
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFFF1F2F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _checked[i]
                                      ? Colors.white
                                      : const Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '点格子切换打卡状态；宽屏下 Wrap 仍然每行 7 个。',
          style: TextStyle(fontSize: 11.5, color: kTextSub),
        ),
      ],
    );
  }
}
