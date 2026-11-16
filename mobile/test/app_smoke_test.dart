import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learners_dic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LEARNERS DIC. opens on the dictionary tab', (tester) async {
    await tester.pumpWidget(const LearnersDic());
    await tester.pump();
    expect(find.text('LEARNERS DIC.'), findsOneWidget);
    expect(find.text('Dictionary'), findsOneWidget);
    expect(find.text('Translate'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
  });
}
