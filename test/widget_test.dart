import 'package:flutter_test/flutter_test.dart';
import 'package:lecture6/main.dart';
import 'package:lecture6/pages/profile_card_page.dart';

void main() {
  testWidgets('首页与名片页可以正常构建', (tester) async {
    await tester.pumpWidget(const Lecture6App());

    expect(find.text('profile_card 个人名片'), findsOneWidget);

    await tester.tap(find.text('profile_card 个人名片'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileCardPage), findsOneWidget);
    expect(find.text('林知夏'), findsOneWidget);
  });
}
