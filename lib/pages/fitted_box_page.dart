// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.3 研究任务 2：FittedBox 三种策略对同一内容的缩放对比。
class FittedBoxPage extends StatelessWidget {
  const FittedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'FittedBox 缩放策略',
      intro:
          '同一份内容（300×64，含四个色块和一行文字）被塞进 100×100 的方框，'
          '分别使用 contain / fill / scaleDown，观察比例与变形差异。',
      children: const [
        SectionHeader('三种 fit 对比', param: 'BoxFit'),
        DemoPanel(
          title: '同一内容 · 三个盒子',
          param: 'contain / fill / scaleDown',
          height: 170,
          child: Row(
            children: [
              Expanded(child: _FitCell(BoxFit.contain)),
              Expanded(child: _FitCell(BoxFit.fill)),
              Expanded(child: _FitCell(BoxFit.scaleDown)),
            ],
          ),
          note: 'contain：等比缩到完全可见，可能留白；fill：拉伸填满，比例会失真；'
              'scaleDown：内容比盒子大时才等比缩小，比盒子小时保持原尺寸（保完整又避免溢出）。',
        ),
        SectionHeader('选型结论', param: '结论'),
        DemoPanel(
          title: '什么时候用 scaleDown',
          param: 'FittedBox',
          height: 120,
          child: Text(
            '· 设计稿固定宽度的卡片放到小屏：FittedBox(fit: BoxFit.scaleDown) 兜底，不裁切不溢出\n'
            '· 图标、价格数字等需要「完整可见」的小组件：contain\n'
            '· 装饰性背景图需要铺满：可用 cover（会裁切），不要用 fill（会变形）',
            style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

class _FitCell extends StatelessWidget {
  const _FitCell(this.fit);

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          color: const Color(0xFFE8ECFB),
          child: FittedBox(
            fit: fit,
            child: Container(
              width: 300,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Container(width: 36, height: 36, color: const Color(0xFF4F6BED)),
                  const SizedBox(width: 6),
                  Container(width: 36, height: 36, color: const Color(0xFF8B5CF6)),
                  const SizedBox(width: 6),
                  Container(width: 36, height: 36, color: const Color(0xFF22C55E)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '固定宽度的内容',
                      style: TextStyle(fontSize: 14),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          fit.name,
          style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
