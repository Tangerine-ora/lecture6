// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.2 任务 2：弹性分配实验——三栏 2:1:1，以及一栏内容超长时开/关 Expanded 的表现。
class FlexPage extends StatefulWidget {
  const FlexPage({super.key});

  @override
  State<FlexPage> createState() => _FlexPageState();
}

class _FlexPageState extends State<FlexPage> {
  bool _useExpanded = true;

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '弹性分配实验',
      intro:
          'Expanded(flex: n) 会把主轴上的剩余空间按比例分给子组件；Flexible 只是允许子组件小于分到的空间。'
          '下面第一张卡验证 2:1:1，第二张卡把 Expanded 关掉，观察长文本被挤出屏幕（RenderFlex overflow）。',
      children: [
        const SectionHeader('① 三栏 2 : 1 : 1', param: 'Expanded(flex: 2/1/1)'),
        const _RatioDemo(),
        const SectionHeader('② 一栏内容超长时', param: 'Expanded 开关'),
        DemoPanel(
          title: _useExpanded ? 'Expanded 开：文字在剩余空间内省略' : 'Expanded 关：出现溢出',
          param: _useExpanded ? 'Expanded' : '无约束',
          height: 110,
          child: Row(
            children: [
              const DemoBox('标签', width: 56, height: 36),
              const SizedBox(width: 10),
              if (_useExpanded)
                const Expanded(child: _LongText())
              else
                const _LongText(),
              const SizedBox(width: 10),
              const Icon(Icons.more_horiz, color: Color(0xFF6B7280)),
            ],
          ),
          note: _useExpanded
              ? 'Expanded 把「可用宽度 - 固定部分」交给 Text，Text 才能在 maxLines + ellipsis 下正常截断。'
              : '此时 Row 给 Text 的是无界宽度，Text 按整行内容报尺寸，超出父约束 → 底部出现黄黑条。'
                    '把开关拨回去即可消除。',
        ),
        SwitchListTile(
          value: _useExpanded,
          onChanged: (v) => setState(() => _useExpanded = v),
          contentPadding: EdgeInsets.zero,
          title: const Text('长文本外面套 Expanded', style: TextStyle(fontSize: 13.5)),
          subtitle: const Text(
            '关掉后控制台会打印 RenderFlex overflowed by xx pixels',
            style: TextStyle(fontSize: 11.5),
          ),
        ),
        const SectionHeader('③ 结论记录', param: '选型'),
        const DemoPanel(
          title: 'Expanded vs Flexible',
          param: '选型',
          height: 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '· 必须占满分到的空间 → Expanded',
                style: TextStyle(fontSize: 12.5, height: 1.8),
              ),
              Text(
                '· 允许子组件比分配空间小（如短文本靠左）→ Flexible',
                style: TextStyle(fontSize: 12.5, height: 1.8),
              ),
              Text(
                '· 无界约束下禁止使用（如 ListView 内直接放 Expanded 会报错）',
                style: TextStyle(fontSize: 12.5, height: 1.8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LongText extends StatelessWidget {
  const _LongText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '这是一段故意写得很长的说明文字，用来占满剩余空间并在空间不足时省略，而不是把整行撑到溢出。',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12.5, height: 1.5),
    );
  }
}

/// 用 LayoutBuilder 读出实际可用宽度，再算 2:1:1 的真实像素值。
class _RatioDemo extends StatelessWidget {
  const _RatioDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth;
          // 两条 8px 固定间距要先从可用宽度里扣掉，剩下的才按 2:1:1 分。
          final unit = (available - 16) / 4;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '可用宽度 ${available.toStringAsFixed(0)} px → 2:1:1 = '
                '${(unit * 2).toStringAsFixed(0)} / ${unit.toStringAsFixed(0)} / '
                '${unit.toStringAsFixed(0)} px',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _RatioBar('flex: 2', unit * 2)),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _RatioBar('flex: 1', unit)),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _RatioBar('flex: 1', unit)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '中间两条有固定间距 8，所以剩余空间先减掉间距再按 2:1:1 分配。',
                style: TextStyle(fontSize: 11.5, height: 1.5, color: Color(0xFF6B7280)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RatioBar extends StatelessWidget {
  const _RatioBar(this.label, this.width);

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF4F6BED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label\n${width.toStringAsFixed(0)}px',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.4),
      ),
    );
  }
}
