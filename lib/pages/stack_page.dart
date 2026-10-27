// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

import '../widgets/lab_widgets.dart';

/// 6.2 任务 3：层叠角标——头像徽标 + 图片浮层文字。
class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: '层叠角标 · Stack',
      intro:
          'Stack 的 children 从底往上依次绘制；Positioned 子项用 left/top/right/bottom 定位，'
          '不参与 Stack 的尺寸计算，非 Positioned 子项才决定 Stack 大小。',
      children: const [
        SectionHeader('① 头像右下角徽标', param: 'Stack + Positioned'),
        DemoPanel(
          title: '在线状态点',
          param: 'right: 2 / bottom: 2',
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AvatarWithBadge(),
              SizedBox(width: 16),
              _AvatarWithBadge(online: false),
            ],
          ),
          note: '头像用 72×72 的 SizedBox 撑起 Stack；徽标 Positioned 在右下角，'
              '叠在头像之上但不影响 Stack 尺寸。对勾徽标是「已认证」，灰点是「离线」。',
        ),
        SectionHeader('② 图片浮层文字', param: 'Stack + fit: expand'),
        DemoPanel(
          title: '头图上的标题',
          param: 'Positioned(left, bottom)',
          height: 200,
          child: _ImageOverlay(),
          note: '底图用 BoxFit.cover 铺满，渐变遮罩保证白字可读，文字 Positioned 在左下角。'
              'Stack 用 StackFit.expand 时，底图会自动撑满父约束。',
        ),
        SectionHeader('③ 尺寸规则', param: 'Inspector'),
        DemoPanel(
          title: '谁决定 Stack 的尺寸',
          param: '非 Positioned',
          height: 92,
          child: Text(
            '· 非 Positioned 子项参与 Stack 尺寸计算（通常是底图）\n'
            '· Positioned 子项只负责定位，不影响 Stack 大小\n'
            '· 想让 Stack 撑满父约束：先放 SizedBox.expand 或底图 fit: BoxFit.cover',
            style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({this.online = true});

  final bool online;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: AssetImage('assets/profile_avatar.png'),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: online ? const Color(0xFF22C55E) : const Color(0xFF9CA3AF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                online ? Icons.check : Icons.remove,
                size: 9,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageOverlay extends StatelessWidget {
  const _ImageOverlay();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/cover_banner.png', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xB3000000)],
              ),
            ),
          ),
          const Positioned(
            left: 14,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Flutter 之夜 · 布局专场',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '2026.10.27  ·  线上直播',
                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
