// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.3 研究任务 1：约束传递实验——复现「撑不满」与「溢出」，并用 Inspector 读约束。
class ConstraintPage extends StatefulWidget {
  const ConstraintPage({super.key});

  @override
  State<ConstraintPage> createState() => _ConstraintPageState();
}

class _ConstraintPageState extends State<ConstraintPage> {
  bool _forceFill = false;
  bool _overflow = false;

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '约束传递实验',
      intro:
          '三句话：父组件把约束传给子组件；子组件在约束内报告自己的尺寸；父组件决定子组件的位置。'
          '「撑不满」通常是因为父给的约束是松约束（min 为 0），子组件按内容尺寸报告；'
          '「溢出」则是约束装不下内容。',
      children: [
        const SectionHeader('现象一：撑不满', param: '松约束'),
        DemoPanel(
          title: _forceFill ? 'width: double.infinity（撑满宽度）' : 'width: 120（按内容尺寸报告）',
          param: _forceFill ? 'double.infinity' : 'width: 120',
          height: 130,
          child: Container(
            color: const Color(0xFFE5E7EB),
            child: Center(
              child: Container(
                width: _forceFill ? double.infinity : 120,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F6BED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '内容块',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          note: 'Center 给子组件的是「0 ≤ w ≤ 父宽」的松约束，子组件报 120 就只画 120。'
              '换成 double.infinity（或外面套 Expanded）才会撑满。',
        ),
        SwitchListTile(
          value: _forceFill,
          onChanged: (v) => setState(() => _forceFill = v),
          contentPadding: EdgeInsets.zero,
          title: const Text('把宽度改为 double.infinity', style: TextStyle(fontSize: 13.5)),
        ),
        const SectionHeader('现象二：溢出', param: '约束超限'),
        DemoPanel(
          title: _overflow ? '内容 6 行 > 容器 120 高' : '内容 3 行，刚好放得下',
          param: _overflow ? 'overflow' : 'fits',
          height: 150,
          child: Container(
            color: const Color(0xFFE5E7EB),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                for (var i = 0; i < (_overflow ? 6 : 3); i++)
                  Container(
                    height: 34,
                    margin: const EdgeInsets.only(bottom: 4),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '第 ${i + 1} 行内容',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
              ],
            ),
          ),
          note: _overflow
              ? 'Column 拿到的最大高度只有 112，6 行共 228 → RenderFlex overflowed by 116 pixels，'
                    '底部出现黄黑警示条。'
              : '3 行共 114，接近上限但仍在约束内，所以没有告警。',
        ),
        SwitchListTile(
          value: _overflow,
          onChanged: (v) => setState(() => _overflow = v),
          contentPadding: EdgeInsets.zero,
          title: const Text('把内容加到 6 行（制造溢出）', style: TextStyle(fontSize: 13.5)),
        ),
        const SectionHeader('用 Inspector 读约束', param: 'DevTools'),
        const DemoPanel(
          title: '操作路径',
          param: 'Widget Inspector',
          height: 120,
          child: Text(
            '1. flutter run -d chrome 后按快捷键打开 DevTools，切到 Widget Inspector\n'
            '2. 点开 Select Widget Mode，选中上面蓝色内容块\n'
            '3. 右侧 Layout Explorer 会显示 constraints（父给的约束）与 size（子报的尺寸）\n'
            '4. 灰色父容器宽度为 W、子块为 120 时，即可证明「子按自身内容报尺寸」',
            style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}
