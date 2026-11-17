import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learners_dic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    DictionaryGateway.client = MockClient((_) async => http.Response('{}', 404));
  });

  Future<void> enterApp(WidgetTester tester) async {
    await tester.pumpWidget(const LearnersDic());
    expect(find.text('Enter the dictionary'), findsOneWidget);
    await tester.tap(find.text('Enter the dictionary'));
    await tester.pumpAndSettle();
  }

  testWidgets('welcome page comes before the dictionary and navigation works', (tester) async {
    await tester.pumpWidget(const LearnersDic());
    expect(find.text('A WORLD OF WORDS'), findsOneWidget);
    expect(find.text('Dictionary'), findsNothing);
    await tester.tap(find.text('Enter the dictionary'));
    await tester.pumpAndSettle();
    expect(find.text('Look up a word'), findsOneWidget);
    for (final label in ['Translate', 'Learn', 'Saved']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('offline common words and inflected form can be found and saved', (tester) async {
    await enterApp(tester);
    await tester.enterText(find.byType(TextField).first, 'children');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('child'), findsOneWidget);
    expect(find.textContaining('plural of child'), findsOneWidget);
    await tester.tap(find.byTooltip('Save word'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Saved').last);
    await tester.pumpAndSettle();
    expect(find.text('child'), findsOneWidget);
  });

  testWidgets('common offline entries work for all six dictionary languages', (tester) async {
    await enterApp(tester);
    const samples = {
      'English': ['hello', 'A greeting'],
      'French': ['bonjour', 'Hello; a polite daytime greeting'],
      'Spanish': ['hola', 'Hello.'],
      'Yorùbá': ['omi', 'Water.'],
      'Igbo': ['mmiri', 'Water.'],
      'Hausa': ['ruwa', 'Water.'],
    };
    for (final sample in samples.entries) {
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(sample.key).last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, sample.value[0]);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text(sample.value[0]), findsWidgets);
      expect(find.textContaining(sample.value[1]), findsOneWidget);
    }
  });

  testWidgets('missing word reports no entry rather than inventing a definition', (tester) async {
    await enterApp(tester);
    await tester.enterText(find.byType(TextField).first, 'zzqv-not-a-word');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('No sourced entry was found'), findsOneWidget);
    expect(find.textContaining('not a word'), findsNothing);
  });

  testWidgets('lesson study, practice, and review spaces are available', (tester) async {
    await enterApp(tester);
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.text('Greetings and first contact'), findsOneWidget);
    expect(find.text('Mark lesson complete'), findsOneWidget);
    await tester.tap(find.text('Mark lesson complete'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 7 lessons complete'), findsOneWidget);
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.textContaining('What does'), findsOneWidget);
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('SPACED REVIEW'), findsOneWidget);
  });

  testWidgets('translator opens with language controls and saved translation area', (tester) async {
    await enterApp(tester);
    await tester.tap(find.text('Translate').last);
    await tester.pumpAndSettle();
    expect(find.text('Translator'), findsOneWidget);
    expect(find.text('FROM'), findsOneWidget);
    expect(find.text('TO'), findsOneWidget);
    expect(find.text('Your translation will appear here.'), findsOneWidget);
  });
}

