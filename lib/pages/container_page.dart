// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.2 任务 4：容器美化——圆角 / 阴影 / 留白 / 渐变 / 剪裁。
class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '容器美化',
      intro:
          'Padding 只负责留白，Container 是组合器（padding + margin + 装饰 + 约束）。'
          '注意：同一个 Container 里 color 和 decoration 不能同时写，颜色要放进 BoxDecoration。',
      children: const [
        SectionHeader('① 白底课程卡', param: 'BoxDecoration'),
        DemoPanel(
          title: '圆角 16 + 阴影 + 留白',
          param: 'radius / shadow',
          height: 112,
          child: _CourseCard(),
          note: '套路：padding 14 + color white + borderRadius 16 + boxShadow(black 6%, blur 12, offset 0,4)，'
              '内层 Row 用 Expanded 托住文字。',
        ),
        SectionHeader('② 渐变横幅', param: 'LinearGradient'),
        DemoPanel(
          title: '渐变 + 圆角',
          param: 'BoxDecoration.gradient',
          height: 110,
          child: _GradientBanner(),
          note: '渐变写在 decoration 里，圆角由 borderRadius 决定；子组件用 Padding 留白。',
        ),
        SectionHeader('③ 图片圆角剪裁', param: 'ClipRRect'),
        DemoPanel(
          title: '头图裁角',
          param: 'ClipRRect(12)',
          height: 170,
          child: _ClipImage(),
          note: 'Image 本身没有圆角属性，靠 ClipRRect 剪裁外层；fit: BoxFit.cover 保证不变形。',
        ),
        SectionHeader('④ 反例', param: '编译错误'),
        DemoPanel(
          title: 'color + decoration 不能共存',
          param: 'Container',
          height: 60,
          child: Text(
            'Container(color: ..., decoration: ...) → 编译报错，'
            '正确写法是把 color 放进 BoxDecoration(color: ...)。',
            style: TextStyle(fontSize: 12, height: 1.6, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF4F6BED).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.widgets_outlined, color: Color(0xFF4F6BED)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '第 6 课 · 基础组件与布局',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Row / Column / Wrap / Stack',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '进行中',
              style: TextStyle(fontSize: 11, color: Color(0xFF16A34A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBanner extends StatelessWidget {
  const _GradientBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F6BED), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F6BED).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '本周目标：照着设计稿还原一个完整静态页面',
              style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipImage extends StatelessWidget {
  const _ClipImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/cover_banner.png',
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
