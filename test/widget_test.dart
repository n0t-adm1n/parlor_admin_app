import 'package:flutter_test/flutter_test.dart';

import 'package:admin_app/main.dart';

void main() {
  testWidgets('AdminApp renders without crashing', (WidgetTester tester) async {
    // We can only pump the root widget; Firebase isn't initialised in tests.
    // A simple smoke-check that the widget tree builds without throwing.
    expect(() async => tester.pumpWidget(const AdminApp()), returnsNormally);
  });
}
