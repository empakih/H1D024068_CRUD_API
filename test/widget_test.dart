import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Login'), findsWidgets);
  });
}
