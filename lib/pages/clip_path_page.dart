// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.3 研究任务 3：用 ClipPath 做异形卡片头图。
class ClipPathPage extends StatelessWidget {
  const ClipPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '自定义剪裁 · ClipPath',
      intro:
          'ClipRRect 只会切圆角，ClipOval 切圆；需要波浪、斜切、缺口这类异形时，'
          '用 ClipPath + 自定义 CustomClipper<Path> 描述轮廓。',
      children: const [
        SectionHeader('① 波浪形头图', param: 'CustomClipper'),
        DemoPanel(
          title: '卡片头图',
          param: 'ClipPath',
          height: 230,
          child: _WaveHeaderCard(),
          note: '路径：上边两个角是直角，底边用两段二次贝塞尔曲线做出波浪；'
              '子图片必须撑满父约束，否则剪裁轮廓会大于图片。',
        ),
        SectionHeader('② 路径要点', param: 'Path'),
        DemoPanel(
          title: '三个关键调用',
          param: 'Path 三方法',
          height: 150,
          child: Text(
            '· moveTo 起点、lineTo 直线、quadraticBezierTo 二次曲线\n'
            '· getClip 返回闭合路径，shouldReclip 返回 true 才会在尺寸变化时重算\n'
            '· ClipPath 会裁剪所有超出路径的内容，图片建议 fit: BoxFit.cover',
            style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

class _WaveHeaderCard extends StatelessWidget {
  const _WaveHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            SizedBox(
              height: 140,
              width: double.infinity,
              child: ClipPath(
                clipper: _WaveClipper(),
                child: Image.asset(
                  'assets/cover_banner.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '波浪头图卡片',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ClipPath 自定义轮廓',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 1.04,
        size.width * 0.5,
        size.height * 0.84,
      )
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.62,
        0,
        size.height * 0.9,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
