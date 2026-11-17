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
    TranslationGateway.client = MockClient((_) async => http.Response('{}', 503));
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

  testWidgets('returning learner skips the welcome page', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    await tester.pumpWidget(const LearnersDic());
    await tester.pumpAndSettle();
    expect(find.text('Look up a word'), findsOneWidget);
    expect(find.text('Enter the dictionary'), findsNothing);
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

  testWidgets('online French entry keeps a sourced definition and example', (tester) async {
    DictionaryGateway.client = MockClient((request) async => http.Response(
      '{"French":[{"partOfSpeech":"interjection","definitions":[{"definition":"Hello; a familiar greeting.","parsedExamples":["Salut, Marie !"],"synonyms":["bonjour"]}]}]}',
      200,
    ));
    await enterApp(tester);
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('French').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'salut');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Hello; a familiar greeting'), findsOneWidget);
    expect(find.textContaining('Salut, Marie !'), findsOneWidget);
    expect(find.textContaining('Synonyms: bonjour'), findsOneWidget);
    DictionaryGateway.client = MockClient((_) async => http.Response('{}', 503));
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Hello; a familiar greeting'), findsOneWidget);
  });

  testWidgets('missing word reports no entry rather than inventing a definition', (tester) async {
    await enterApp(tester);
    await tester.enterText(find.byType(TextField).first, 'zzqv-not-a-word');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('No sourced entry was found'), findsOneWidget);
    expect(find.textContaining('not a word'), findsNothing);
  });

  testWidgets('sourced English lookup tries a documented base form for common inflections', (tester) async {
    DictionaryGateway.client = MockClient((request) async {
      if (request.url.path.endsWith('/walked')) return http.Response('{}', 404);
      if (request.url.path.endsWith('/walk')) {
        return http.Response(
          '{"English":[{"partOfSpeech":"verb","definitions":[{"definition":"To move on foot.","parsedExamples":["We walk to school."]}]}]}',
          200,
        );
      }
      return http.Response('{}', 404);
    });
    await enterApp(tester);
    await tester.enterText(find.byType(TextField).first, 'walked');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Showing the sourced base entry “walk”'), findsOneWidget);
    expect(find.textContaining('To move on foot'), findsOneWidget);
  });

  testWidgets('lesson study, practice, and review spaces are available', (tester) async {
    await enterApp(tester);
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.text('Say hello'), findsOneWidget);
    expect(find.text('WORDS TO KNOW'), findsOneWidget);
    expect(find.text('Bonjour, je m’appelle Ada.'), findsOneWidget);
    await tester.ensureVisible(find.text('Check a model answer'));
    await tester.tap(find.text('Check a model answer'));
    await tester.pumpAndSettle();
    expect(find.text('Bonjour, je m’appelle [your name].'), findsOneWidget);
    await tester.ensureVisible(find.text('Mark lesson complete'));
    expect(find.text('Mark lesson complete'), findsOneWidget);
    await tester.tap(find.text('Mark lesson complete'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.textContaining('of 7 lessons complete'));
    expect(find.text('1 of 7 lessons complete'), findsOneWidget);
    await tester.ensureVisible(find.text('Practice'));
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Which French phrase means'), findsOneWidget);
    await tester.ensureVisible(find.text('Review'));
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('SPACED REVIEW'), findsOneWidget);
  });

  testWidgets('translator opens with language controls and saved translation area', (tester) async {
    await enterApp(tester);
    await tester.tap(find.text('Translate').first);
    await tester.pumpAndSettle();
    expect(find.text('Translator'), findsOneWidget);
    expect(find.text('FROM'), findsOneWidget);
    expect(find.text('TO'), findsOneWidget);
    expect(find.text('Your translation will appear here.'), findsOneWidget);
  });

  testWidgets('translator returns a result and saves its history', (tester) async {
    TranslationGateway.client = MockClient((request) async => http.Response(
      '{"responseStatus":200,"responseData":{"translatedText":"Bonjour"}}',
      200,
    ));
    await enterApp(tester);
    await tester.tap(find.text('Translate').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Hello');
    await tester.tap(find.text('Translate').first);
    await tester.pumpAndSettle();
    expect(find.text('Bonjour'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.textContaining('English → French'), findsOneWidget);
  });

  testWidgets('lesson completion survives an app restart', (tester) async {
    await enterApp(tester);
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark lesson complete'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const LearnersDic());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.text('1 of 7 lessons complete'), findsOneWidget);
  });
}
