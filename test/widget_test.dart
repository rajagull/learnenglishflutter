import 'package:flutter_test/flutter_test.dart';
import 'package:learnenglishflutter/main.dart';

void main() {
  testWidgets('LearnEnglishApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnEnglishApp());
    expect(find.byType(LearnEnglishApp), findsOneWidget);
  });
}
