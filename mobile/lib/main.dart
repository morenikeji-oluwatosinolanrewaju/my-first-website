import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const LearnersDictionaryApp());

const ink = Color(0xFF17231E);
const forest = Color(0xFF315B48);
const paper = Color(0xFFF5F3EC);
const muted = Color(0xFF78827B);
const line = Color(0xFFE5E5DC);

class LearnersDictionaryApp extends StatelessWidget {
  const LearnersDictionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEARNERS DIC.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: paper),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(backgroundColor: paper, foregroundColor: ink, elevation: 0),
      ),
      home: const DictionaryShell(),
    );
  }
}

class DictionaryShell extends StatefulWidget {
  const DictionaryShell({super.key});
  @override
  State<DictionaryShell> createState() => _DictionaryShellState();
}

class _DictionaryShellState extends State<DictionaryShell> {
  int tab = 0;
  final search = TextEditingController();
  String selectedLanguage = 'English';
  final languages = const ['English', 'French', 'Spanish', 'Yorùbá', 'Igbo', 'Hausa'];
  final Map<String, List<WordEntry>> entries = {
    'English': [
      WordEntry('abandon', '/əˈbændən/', 'verb', 'To leave someone or something behind; to give up an activity or course of action.', ['They had to abandon the journey.'], 'Middle English, from Old French abandoner.'),
      WordEntry('benevolent', '/bəˈnevələnt/', 'adjective', 'Well meaning and kindly; showing goodwill towards others.', ['A benevolent leader helped the village.'], 'From Latin bene “well” + volent “wishing”.'),
      WordEntry('eloquent', '/ˈeləkwənt/', 'adjective', 'Fluent or persuasive in speaking or writing.', ['Her explanation was clear and eloquent.'], 'From Latin eloqui, “to speak out”.'),
      WordEntry('lexicon', '/ˈleksɪkɒn/', 'noun', 'The vocabulary of a person, language, or branch of knowledge.', ['The technical lexicon of medicine.'], 'From Greek lexikon, “of words”.'),
    ],
  };
  WordEntry? result;
  bool searched = false;

  void lookup() {
    final q = search.text.trim().toLowerCase();
    setState(() {
      searched = q.isNotEmpty;
      result = null;
      for (final entry in entries[selectedLanguage] ?? <WordEntry>[]) {
        if (entry.word.toLowerCase() == q) { result = entry; break; }
      }
      tab = 0;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() { search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pages = [
      dictionaryPage(),
      const FeaturePage(title: 'Translator', eyebrow: 'LANGUAGE TO LANGUAGE', description: 'A dedicated translation workspace is being built. It will use a defined translation source, not an AI chat screen.', icon: Icons.translate_rounded),
      const FeaturePage(title: 'Learn', eyebrow: 'LANGUAGE STUDY', description: 'Structured courses, grammar, vocabulary, listening and revision will live here.', icon: Icons.school_outlined),
      const FeaturePage(title: 'Saved words', eyebrow: 'YOUR WORD COLLECTION', description: 'Save dictionary entries here for later review.', icon: Icons.bookmark_border_rounded),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFFCFBF7),
        indicatorColor: const Color(0xFFE2EAE3),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Dictionary'),
          NavigationDestination(icon: Icon(Icons.translate_rounded), label: 'Translate'),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Saved'),
        ],
      ),
    );
  }

  Widget dictionaryPage() => CustomScrollView(
    slivers: [
      SliverPadding(padding: const EdgeInsets.fromLTRB(22, 22, 22, 28), sliver: SliverList(delegate: SliverChildListDelegate([
        Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text('LD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: -1))),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('LEARNERS DIC.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: ink)), Text('A WORLD OF WORDS', style: TextStyle(fontSize: 9, letterSpacing: 1.6, color: muted))]),
          const Spacer(),
          IconButton(onPressed: () => setState(() => tab = 3), icon: const Icon(Icons.bookmark_border, color: ink)),
        ]),
        const SizedBox(height: 36),
        const Text('THE DICTIONARY', style: TextStyle(color: forest, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
        const SizedBox(height: 8),
        const Text('Find the exact\nword you need.', style: TextStyle(fontSize: 34, height: 1.12, fontWeight: FontWeight.w700, letterSpacing: -1.2, color: ink)),
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('DICTIONARY LANGUAGE', style: TextStyle(fontSize: 9, letterSpacing: 1.4, color: muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, value: selectedLanguage, items: languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(), onChanged: (v) => setState(() { selectedLanguage = v!; result = null; searched = false; }))),
          const Divider(height: 14, color: line),
          Row(children: [
            Expanded(child: TextField(controller: search, onSubmitted: (_) => lookup(), textInputAction: TextInputAction.search, decoration: const InputDecoration(hintText: 'Search a word…', border: InputBorder.none, isDense: true))),
            IconButton.filled(onPressed: lookup, style: IconButton.styleFrom(backgroundColor: forest, foregroundColor: Colors.white), icon: const Icon(Icons.search)),
          ]),
        ])),
        const SizedBox(height: 22),
        if (result != null) WordCard(entry: result!)
        else if (searched) InfoPanel(title: 'Entry not found in this build', body: 'This initial native build contains a small demonstration set only. The full verified dictionary collection has not been connected yet.')
        else ...[
          const Text('WORD DESK', style: TextStyle(fontSize: 10, letterSpacing: 1.6, color: muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const InfoPanel(title: 'Dictionary foundation', body: 'Search, entry structure and native navigation are in place. The production dictionary database, full language coverage, audio and editorial sources are the next build stages.'),
        ],
        const SizedBox(height: 18),
        const Text('BUILT AS A DICTIONARY', style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: muted, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        const Text('Definitions · Phonetics · Parts of speech · Etymology · Examples · Word relationships', style: TextStyle(color: muted, height: 1.5, fontSize: 12)),
      ]))),
    ],
  );
}

class WordEntry {
  final String word, pronunciation, partOfSpeech, definition, origin;
  final List<String> examples;
  const WordEntry(this.word, this.pronunciation, this.partOfSpeech, this.definition, this.examples, this.origin);
}

class WordCard extends StatelessWidget {
  final WordEntry entry;
  const WordCard({super.key, required this.entry});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(entry.partOfSpeech.toUpperCase(), style: const TextStyle(color: forest, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
    const SizedBox(height: 5),
    Text(entry.word, style: const TextStyle(color: ink, fontSize: 30, fontWeight: FontWeight.w700)),
    Text(entry.pronunciation, style: const TextStyle(color: muted, fontSize: 14)),
    const Divider(height: 28, color: line),
    const Text('DEFINITION', style: TextStyle(fontSize: 9, letterSpacing: 1.4, color: muted, fontWeight: FontWeight.w700)),
    const SizedBox(height: 7),
    Text(entry.definition, style: const TextStyle(fontSize: 15, height: 1.5, color: ink)),
    const SizedBox(height: 18),
    const Text('EXAMPLE', style: TextStyle(fontSize: 9, letterSpacing: 1.4, color: muted, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    ...entry.examples.map((e) => Text('“$e”', style: const TextStyle(fontSize: 14, height: 1.5, color: ink))),
    const SizedBox(height: 18),
    const Text('WORD ORIGIN', style: TextStyle(fontSize: 9, letterSpacing: 1.4, color: muted, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    Text(entry.origin, style: const TextStyle(fontSize: 13, height: 1.45, color: muted)),
  ]));
}

class InfoPanel extends StatelessWidget {
  final String title, body;
  const InfoPanel({super.key, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFECEFE8), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: ink, fontSize: 15)),
    const SizedBox(height: 6),
    Text(body, style: const TextStyle(color: muted, fontSize: 13, height: 1.5)),
  ]));
}

class FeaturePage extends StatelessWidget {
  final String title, eyebrow, description;
  final IconData icon;
  const FeaturePage({super.key, required this.title, required this.eyebrow, required this.description, required this.icon});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 14),
    const Text('LEARNERS DIC.', style: TextStyle(fontSize: 14, letterSpacing: 1.2, fontWeight: FontWeight.w800, color: ink)),
    const Spacer(),
    Icon(icon, size: 42, color: forest),
    const SizedBox(height: 22),
    Text(eyebrow, style: const TextStyle(color: forest, fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8),
    Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: ink, letterSpacing: -1)),
    const SizedBox(height: 12),
    Text(description, style: const TextStyle(color: muted, fontSize: 15, height: 1.6)),
    const Spacer(),
    const Text('A dictionary first. Learning tools built around real language data.', style: TextStyle(color: muted, fontSize: 11, height: 1.5)),
    const SizedBox(height: 16),
  ]));
}
