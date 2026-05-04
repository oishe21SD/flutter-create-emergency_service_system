import 'package:flutter_test/flutter_test.dart';
import 'package:emergency_service_system/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Emergency Help Desk'), findsOneWidget);
  });
}
