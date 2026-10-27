import 'package:flutter/material.dart';

import '../../widgets/lab_widgets.dart';

/// 6A · EX5 朋友圈卡片修复版。
/// 病根：右上角「赞 / 评论」只是一排 Icon，没有挂点击。
/// 修复：按钮外层套 InkWell，点击弹出菜单，可点赞 / 取消点赞，也可写评论并即时上屏。
class Ex5MomentsPage extends StatefulWidget {
  const Ex5MomentsPage({super.key});

  @override
  State<Ex5MomentsPage> createState() => _Ex5MomentsPageState();
}

class _Ex5MomentsPageState extends State<Ex5MomentsPage> {
  static const _photoColors = [
    Color(0xFF90CAF9),
    Color(0xFFFFCC80),
    Color(0xFFA5D6A7),
    Color(0xFFEF9A9A),
    Color(0xFFCE93D8),
    Color(0xFF80DEEA),
    Color(0xFFFFF59D),
    Color(0xFFBCAAA4),
    Color(0xFFB0BEC5),
  ];

  final List<String> _liked = ['胡老师'];
  final List<_Comment> _comments = [
    _Comment('小云', '这就是卡片套路的实战版！'),
    _Comment('阿吉', 'Wrap 九宫格学到了'),
  ];

  bool get _selfLiked => _liked.contains('我');

  void _toggleSelfLike() {
    setState(() {
      if (_selfLiked) {
        _liked.remove('我');
      } else {
        _liked.add('我');
      }
    });
  }

  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                _selfLiked ? Icons.favorite : Icons.favorite_border,
                color: _selfLiked ? Colors.redAccent : null,
              ),
              title: Text(_selfLiked ? '取消点赞' : '点赞'),
              onTap: () {
                Navigator.of(ctx).pop();
                _toggleSelfLike();
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('写评论'),
              onTap: () {
                Navigator.of(ctx).pop();
                _openCommentDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCommentDialog() async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('写评论'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
          decoration: const InputDecoration(hintText: '说点什么……'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('发送'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || text == null || text.isEmpty) return;
    setState(() => _comments.add(_Comment('我', text)));
  }

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'EX5 朋友圈卡片 · 修复版',
      intro:
          '病根：右上角按钮只是一排 Icon，完全没有点击回调。'
          '修复后点它弹出菜单：点赞会立刻变成红心并进入点赞列表，写评论会弹输入框并把评论加到卡片里。',
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 46,
                    height: 46,
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 23,
                          backgroundImage: AssetImage('assets/profile_avatar.png'),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '胡老师',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5B7DB1),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '2 小时前',
                          style: TextStyle(fontSize: 11.5, color: Colors.black38),
                        ),
                      ],
                    ),
                  ),
                  // 关键修复：给菜单按钮挂上点击
                  Material(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: _openMenu,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.more_horiz, size: 18, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 14, height: 1.55),
                  children: [
                    const TextSpan(text: '今天第 6 课：把第 3~5 章的组件做成了 23 个演示页。\n'),
                    TextSpan(
                      text: '#Flutter基础组件# ',
                      style: const TextStyle(color: Color(0xFF5B7DB1)),
                    ),
                    TextSpan(
                      text: '#布局系统#',
                      style: const TextStyle(color: Color(0xFF5B7DB1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 240,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final c in _photoColors)
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.photo,
                          color: Colors.white24,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 13,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _liked.join('、'),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF5B7DB1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (final c in _comments)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${c.author}：',
                                style: const TextStyle(
                                  color: Color(0xFF5B7DB1),
                                  fontSize: 12.5,
                                ),
                              ),
                              TextSpan(
                                text: c.text,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _toggleSelfLike,
                icon: Icon(
                  _selfLiked ? Icons.favorite : Icons.favorite_border,
                  size: 17,
                  color: _selfLiked ? Colors.redAccent : null,
                ),
                label: Text(_selfLiked ? '已赞' : '点赞'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openCommentDialog,
                icon: const Icon(Icons.chat_bubble_outline, size: 17),
                label: const Text('评论'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Comment {
  const _Comment(this.author, this.text);

  final String author;
  final String text;
}
