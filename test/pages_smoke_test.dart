import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture6/pages/alignment_page.dart';
import 'package:lecture6/pages/clip_path_page.dart';
import 'package:lecture6/pages/constraint_page.dart';
import 'package:lecture6/pages/container_page.dart';
import 'package:lecture6/pages/ex/ex1_boom_page.dart';
import 'package:lecture6/pages/ex/ex2_ledger_page.dart';
import 'package:lecture6/pages/ex/ex3_calendar_page.dart';
import 'package:lecture6/pages/ex/ex4_wheel_page.dart';
import 'package:lecture6/pages/ex/ex5_moments_page.dart';
import 'package:lecture6/pages/fitted_box_page.dart';
import 'package:lecture6/pages/flex_page.dart';
import 'package:lecture6/pages/profile_card_page.dart';
import 'package:lecture6/pages/stack_page.dart';

/// 回归测试：所有页面在手机与宽屏两种尺寸下都能构建，且没有 RenderFlex 溢出。
void main() {
  final pages = <String, Widget Function()>{
    'profile_card': () => const ProfileCardPage(),
    '对齐任务卡': () => const AlignmentPage(),
    '弹性分配': () => const FlexPage(),
    '层叠角标': () => const StackPage(),
    '容器美化': () => const ContainerPage(),
    '约束传递': () => const ConstraintPage(),
    'FittedBox': () => const FittedBoxPage(),
    'ClipPath': () => const ClipPathPage(),
    'EX1': () => const Ex1BoomPage(),
    'EX2': () => const Ex2LedgerPage(),
    'EX3': () => const Ex3CalendarPage(),
    'EX4': () => const Ex4WheelPage(),
    'EX5': () => const Ex5MomentsPage(),
  };

  const sizes = {'手机 390x844': Size(390, 844), '宽屏 900x900': Size(900, 900)};

  for (final entry in pages.entries) {
    for (final sizeEntry in sizes.entries) {
      testWidgets('${entry.key} @ ${sizeEntry.key} 无溢出', (tester) async {
        tester.view.physicalSize = sizeEntry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(MaterialApp(home: entry.value()));
        await tester.pump(const Duration(milliseconds: 120));

        // 任何布局异常（含 RenderFlex overflow）都会让这条断言失败。
        expect(tester.takeException(), isNull);
      });
    }
  }
}
