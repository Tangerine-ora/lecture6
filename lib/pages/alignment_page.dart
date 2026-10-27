// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.2 任务 1：对齐任务卡——六个对齐场景逐一实现并标注参数。
class AlignmentPage extends StatelessWidget {
  const AlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '对齐任务卡 · 六种场景',
      intro:
          'Row 的主轴是水平方向，Column 的主轴是垂直方向。mainAxisAlignment 管主轴上的排布，'
          'crossAxisAlignment 管交叉轴上的对齐。下面六张卡按参数从「靠边」到「均分」排列，'
          '每张卡右上角标注了实际参数。',
      children: const [
        SectionHeader('主轴对齐 · Row', param: 'mainAxis'),
        DemoPanel(
          title: '① 起点对齐',
          param: 'MainAxisAlignment.start',
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DemoBox('A', color: Color(0xFF4F6BED)),
              DemoBox('B', color: Color(0xFF7C93F5)),
              DemoBox('C', color: Color(0xFFA5B4FB)),
            ],
          ),
          note: '默认值。三个方块贴着左侧，剩余空间全部留在右边。',
        ),
        DemoPanel(
          title: '② 居中对齐',
          param: 'MainAxisAlignment.center',
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DemoBox('A', color: Color(0xFF4F6BED)),
              DemoBox('B', color: Color(0xFF7C93F5)),
              DemoBox('C', color: Color(0xFFA5B4FB)),
            ],
          ),
          note: '方块整体居中，左右两侧空白相等。',
        ),
        DemoPanel(
          title: '③ 末端对齐',
          param: 'MainAxisAlignment.end',
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DemoBox('A', color: Color(0xFF4F6BED)),
              DemoBox('B', color: Color(0xFF7C93F5)),
              DemoBox('C', color: Color(0xFFA5B4FB)),
            ],
          ),
          note: '方块靠右，空白集中在左侧。常用于工具栏右侧的操作按钮。',
        ),
        DemoPanel(
          title: '④ 两端对齐',
          param: 'MainAxisAlignment.spaceBetween',
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DemoBox('A', color: Color(0xFF4F6BED)),
              DemoBox('B', color: Color(0xFF7C93F5)),
              DemoBox('C', color: Color(0xFFA5B4FB)),
            ],
          ),
          note: '首尾贴边，中间的间隔被均分。标题 + 操作按钮最常用这个。',
        ),
        DemoPanel(
          title: '⑤ 均匀分布',
          param: 'MainAxisAlignment.spaceEvenly',
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DemoBox('A', color: Color(0xFF4F6BED)),
              DemoBox('B', color: Color(0xFF7C93F5)),
              DemoBox('C', color: Color(0xFFA5B4FB)),
            ],
          ),
          note: '包含两端在内的所有间隔相等（spaceAround 则是两端间隔为中间的一半）。',
        ),
        SectionHeader('交叉轴对齐 · Column', param: 'crossAxis'),
        DemoPanel(
          title: '⑥ 左对齐（交叉轴起点）',
          param: 'CrossAxisAlignment.start',
          height: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoBox('宽 48', color: Color(0xFF4F6BED)),
              DemoBox('宽 96', width: 96, color: Color(0xFF7C93F5)),
              DemoBox('宽 144', width: 144, color: Color(0xFFA5B4FB)),
            ],
          ),
          note: 'Column 默认水平居中（center）；改成 start 后左边缘对齐，宽度仍由各自内容决定。',
        ),
      ],
    );
  }
}
