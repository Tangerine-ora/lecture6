import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/lab_widgets.dart';

/// 6A · EX2 迷你记账本修复版。
/// 病根：右下角「+」没挂 onPressed；没有输入金额、选标签、新增记录的逻辑。
/// 修复：FAB 打开底部输入面板（标题 / 金额 / 标签），校验通过后插入列表并更新合计。
class Ex2LedgerPage extends StatefulWidget {
  const Ex2LedgerPage({super.key});

  @override
  State<Ex2LedgerPage> createState() => _Ex2LedgerPageState();
}

class _Ex2LedgerPageState extends State<Ex2LedgerPage> {
  final List<_LedgerItem> _items = [
    _LedgerItem('早餐', 15.5, _LedgerTag('餐饮', Color(0xFFF97316))),
    _LedgerItem('地铁', 6.0, _LedgerTag('交通', Color(0xFF3B82F6))),
    _LedgerItem('午餐', 28.0, _LedgerTag('餐饮', Color(0xFFF97316))),
    _LedgerItem('买书', 59.0, _LedgerTag('学习', Color(0xFF8B5CF6))),
    _LedgerItem('奶茶', 18.0, _LedgerTag('饮料', Color(0xFFEC4899))),
  ];

  double get _total =>
      _items.fold(0, (sum, item) => sum + item.amount);

  Future<void> _openAddSheet() async {
    final item = await showModalBottomSheet<_LedgerItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddSheet(),
    );
    if (item == null || !mounted) return;
    setState(() => _items.insert(0, item));
  }

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: 'EX2 迷你记账本 · 修复版',
      intro:
          '病根：FAB 只是装饰，没有 onPressed；输入区、标签选中态、列表新增逻辑整体缺失。'
          '修复后点「记一笔」会弹出底部输入面板，金额校验通过才允许保存。',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
      children: [
        SectionHeader('本月合计', param: '${_items.length} 笔'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4F6BED), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '总支出',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                '¥ ${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '最近一笔：${_items.first.title}',
                style: const TextStyle(color: Colors.white70, fontSize: 11.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeader('支出明细', param: 'ListView.separated'),
        for (final item in _items) _LedgerRow(item: item),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.item});

  final _LedgerItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(radius: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.tag.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.tag.icon, size: 18, color: item.tag.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: item.tag.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.tag.name,
                    style: TextStyle(fontSize: 10.5, color: item.tag.color),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-¥${item.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSheet extends StatefulWidget {
  const _AddSheet();

  @override
  State<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<_AddSheet> {
  static const _tagOptions = [
    _LedgerTag('餐饮', Color(0xFFF97316)),
    _LedgerTag('交通', Color(0xFF3B82F6)),
    _LedgerTag('学习', Color(0xFF8B5CF6)),
    _LedgerTag('饮料', Color(0xFFEC4899)),
    _LedgerTag('其他', Color(0xFF6B7280)),
  ];

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  int _tagIndex = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  bool get _valid {
    final amount = double.tryParse(_amountController.text.trim());
    return _titleController.text.trim().isNotEmpty &&
        amount != null &&
        amount > 0;
  }

  void _submit() {
    if (!_valid) return;
    Navigator.of(context).pop(
      _LedgerItem(
        _titleController.text.trim(),
        double.parse(_amountController.text.trim()),
        _tagOptions[_tagIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '记一笔',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: '名称',
              hintText: '例如：晚餐',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: '金额（元）',
              hintText: '0.00',
              prefixText: '¥ ',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 14),
          const Text('标签', style: TextStyle(fontSize: 12.5, color: kTextSub)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _tagOptions.length; i++)
                ChoiceChip(
                  label: Text(_tagOptions[i].name),
                  selected: _tagIndex == i,
                  selectedColor: _tagOptions[i].color.withValues(alpha: 0.16),
                  onSelected: (_) => setState(() => _tagIndex = i),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _valid ? _submit : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
              ),
              child: const Text('保存'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerItem {
  const _LedgerItem(this.title, this.amount, this.tag);

  final String title;
  final double amount;
  final _LedgerTag tag;
}

class _LedgerTag {
  const _LedgerTag(this.name, this.color);

  final String name;
  final Color color;

  IconData get icon => switch (name) {
    '餐饮' => Icons.restaurant,
    '交通' => Icons.directions_subway,
    '学习' => Icons.menu_book,
    '饮料' => Icons.local_cafe,
    _ => Icons.receipt_long,
  };
}
