import 'package:flutter_test/flutter_test.dart';
import 'package:telugu_varnamala/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TeluguVarnamalaApp());
    expect(find.text('Telugu Varnamala'), findsOneWidget);
  });
}
