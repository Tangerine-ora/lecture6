import 'package:flutter/material.dart';

import 'pages/alignment_page.dart';
import 'pages/clip_path_page.dart';
import 'pages/constraint_page.dart';
import 'pages/container_page.dart';
import 'pages/ex/ex1_boom_page.dart';
import 'pages/ex/ex2_ledger_page.dart';
import 'pages/ex/ex3_calendar_page.dart';
import 'pages/ex/ex4_wheel_page.dart';
import 'pages/ex/ex5_moments_page.dart';
import 'pages/fitted_box_page.dart';
import 'pages/flex_page.dart';
import 'pages/profile_card_page.dart';
import 'pages/stack_page.dart';
import 'widgets/lab_widgets.dart';

void main() {
  runApp(const Lecture6App());
}

class Lecture6App extends StatelessWidget {
  const Lecture6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 第6课 · 基础组件与布局系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0.5,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 第6课 · 实践作业')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _IntroCard(),
          const _GroupHeader('6.1 案例复现（必做）'),
          _EntryCard(
            icon: Icons.badge_outlined,
            title: 'profile_card 个人名片',
            subtitle: '骨架 / 卡片装饰 / 设计稿对照',
            onTap: () => _open(context, const ProfileCardPage()),
          ),
          const _GroupHeader('6.2 自主实践基本要求（必做）'),
          _EntryCard(
            icon: Icons.align_horizontal_left,
            title: '对齐任务卡 · 六种场景',
            subtitle: 'mainAxisAlignment / crossAxisAlignment 参数对照',
            onTap: () => _open(context, const AlignmentPage()),
          ),
          _EntryCard(
            icon: Icons.view_column_outlined,
            title: '弹性分配实验',
            subtitle: '2:1:1 三栏 + 长文本开关 Expanded',
            onTap: () => _open(context, const FlexPage()),
          ),
          _EntryCard(
            icon: Icons.layers_outlined,
            title: '层叠角标',
            subtitle: '头像徽标 + 图片浮层文字',
            onTap: () => _open(context, const StackPage()),
          ),
          _EntryCard(
            icon: Icons.style_outlined,
            title: '容器美化',
            subtitle: '圆角 / 阴影 / 留白 / 渐变 / 剪裁',
            onTap: () => _open(context, const ContainerPage()),
          ),
          const _GroupHeader('6.3 独立研究任务（选做）'),
          _EntryCard(
            icon: Icons.straighten,
            title: '约束传递实验',
            subtitle: '撑不满 / 溢出 + Inspector 读约束',
            onTap: () => _open(context, const ConstraintPage()),
          ),
          _EntryCard(
            icon: Icons.fit_screen_outlined,
            title: 'FittedBox 缩放策略',
            subtitle: 'contain / fill / scaleDown 对比',
            onTap: () => _open(context, const FittedBoxPage()),
          ),
          _EntryCard(
            icon: Icons.crop_original,
            title: '自定义剪裁',
            subtitle: 'ClipPath 异形卡片头图',
            onTap: () => _open(context, const ClipPathPage()),
          ),
          const _GroupHeader('6A 扩展练习：修复演示站五个案例（选做）'),
          _EntryCard(
            icon: Icons.celebration_outlined,
            title: 'EX1 热区彩蛋',
            subtitle: '粒子爆炸动画 + 随机金币奖励',
            onTap: () => _open(context, const Ex1BoomPage()),
          ),
          _EntryCard(
            icon: Icons.receipt_long_outlined,
            title: 'EX2 迷你记账本',
            subtitle: 'FAB 打开输入面板，可新增记录',
            onTap: () => _open(context, const Ex2LedgerPage()),
          ),
          _EntryCard(
            icon: Icons.calendar_month_outlined,
            title: 'EX3 打卡日历',
            subtitle: '固定 40 格子，宽屏仍 7 列',
            onTap: () => _open(context, const Ex3CalendarPage()),
          ),
          _EntryCard(
            icon: Icons.casino_outlined,
            title: 'EX4 抽奖转盘',
            subtitle: '扇区可见旋转，结果与指针一致',
            onTap: () => _open(context, const Ex4WheelPage()),
          ),
          _EntryCard(
            icon: Icons.forum_outlined,
            title: 'EX5 朋友圈卡片',
            subtitle: '赞 / 评论菜单可点击',
            onTap: () => _open(context, const Ex5MomentsPage()),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F6BED), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '基础组件与布局系统',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '名片复现 · 对齐 / 弹性 / 层叠 / 容器 · 5 个扩展案例修复',
            style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: kTextSub,
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: kPrimary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: kTextSub),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
