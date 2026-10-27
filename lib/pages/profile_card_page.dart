import 'package:flutter/material.dart';

/// 课堂案例复现：个人名片页 profile_card。
/// 步骤一：只搭结构与对齐——头像、姓名签名、统计条（三个 Expanded）、标签云（Wrap）。
class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  static const List<String> _tags = ['Flutter', '布局系统', '卡片套路', '摄影', '夜跑'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人名片 · profile_card')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 头像
          const Center(
            child: CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage('assets/profile_avatar.png'),
            ),
          ),
          const SizedBox(height: 12),
          // 姓名与签名（两行 Text）
          const Center(
            child: Text(
              '林知夏',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Flutter 学习者 · 用布局把想法摆整齐',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
          // 统计条：三个 Expanded 等分 Row
          Row(
            children: [
              Expanded(child: _StatBlock(value: '128', label: '关注')),
              Expanded(child: _StatBlock(value: '2.4k', label: '粉丝')),
              Expanded(child: _StatBlock(value: '9.8k', label: '获赞')),
            ],
          ),
          const SizedBox(height: 20),
          // 标签云：Wrap 自动换行
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final t in _tags) Text(t)],
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
