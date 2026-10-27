import 'package:flutter/material.dart';

/// 全局配色：主色靛蓝，页面底色浅灰蓝。
const Color kPrimary = Color(0xFF4F6BED);
const Color kBg = Color(0xFFF3F5F9);
const Color kTextSub = Color(0xFF6B7280);

/// 实验页通用骨架：标题 + 说明 + 可滚动内容。
class LabScaffold extends StatelessWidget {
  const LabScaffold({
    super.key,
    required this.title,
    required this.intro,
    required this.children,
  });

  final String title;
  final String intro;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _IntroBox(text: intro),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _IntroBox extends StatelessWidget {
  const _IntroBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: kPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, height: 1.55, color: kTextSub),
            ),
          ),
        ],
      ),
    );
  }
}

/// 小节标题，可带参数标注。
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.param});

  final String text;
  final String? param;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          if (param != null) ParamChip(param!),
        ],
      ),
    );
  }
}

class ParamChip extends StatelessWidget {
  const ParamChip(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: kPrimary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: kPrimary, height: 1.4),
      ),
    );
  }
}

/// 单个对照实验面板：标题 + 参数 + 演示区 + 一句话说明。
class DemoPanel extends StatelessWidget {
  const DemoPanel({
    super.key,
    required this.title,
    required this.param,
    required this.child,
    this.note,
    this.height,
  });

  final String title;
  final String param;
  final Widget child;
  final String? note;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              ParamChip(param),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              note!,
              style: const TextStyle(fontSize: 11.5, height: 1.5, color: kTextSub),
            ),
          ],
        ],
      ),
    );
  }
}

/// 演示用的色块方块。
class DemoBox extends StatelessWidget {
  const DemoBox(
    this.label, {
    super.key,
    this.width = 48,
    this.height = 48,
    this.color = kPrimary,
  });

  final String label;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

/// 白底卡片套路，先背下来再用。
BoxDecoration cardDecoration({Color color = Colors.white, double radius = 16}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
