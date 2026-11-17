# LEARNERS DIC. — A WORLD OF WORDS

LEARNERS DIC. is a native Flutter language-learning app for Android, iOS, Windows and macOS. The first screen is a welcome page; after entering, the bottom navigation leads to Dictionary, Translate, Learn and Saved.

## What is implemented

- Six dictionary language choices: English, French, Spanish, Yorùbá, Igbo and Hausa.
- A small bundled offline starter vocabulary. Online searches use the structured definition endpoint on English Wiktionary; opened results are cached on the device and can be revisited offline.
- Common English inflections can fall back to a sourced base form (for example, `walked` to `walk`); the app labels the lemma it found. This is a bounded spelling rule set, not a full morphological analyzer.
- Sourced definitions and available examples, part of speech, semantic relations, etymology and pronunciation fields. Device text-to-speech can read a headword or lesson phrase when a suitable voice is installed.
- Explicit missing-entry and connection messages. The app does not fill gaps with generated definitions.
- A dedicated MyMemory translator for the six language choices, with recent translations, copy and speech controls. Machine output can be weak for less-resourced languages and should be checked.
- A seven-lesson beginner foundation course with model phrases, study notes, optional speech playback, multiple-choice recall and locally saved completion.
- Saved words and progress stored locally through SharedPreferences.

## Dictionary data and limits

The bundled word list is an introductory convenience list, not a substantial lexicon. The app has on-demand access to Wiktionary, a large community-maintained multilingual lexical source; it does not bundle Wiktionary snapshots or guarantee coverage. A word must have an entry in the selected language inside the English Wiktionary definitions response. Coverage and editorial quality vary, especially for Yorùbá, Igbo and Hausa. The app reports an unavailable entry instead of inventing one. Search requires a connection unless the exact entry was previously opened and cached.

Wiktionary content is licensed under [Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/) and the GNU Free Documentation License. See the [Wikimedia Wiktionary data overview](https://enterprise.wikimedia.com/project-data/wiktionary-api/) for the dataset and licensing details. The app identifies Wiktionary contributors, links to the source entry and names the licence on result cards. Definitions are adapted only to remove markup for display; redistributed Wiktionary text must retain attribution and comply with the applicable share-alike terms. The bundled starter phrases are authored for this app and are not represented as Wiktionary data. Regional forms, diacritics, register and examples should be reviewed with qualified speakers before the lessons are treated as authoritative.

## Build and verify

From `mobile/`, run `flutter pub get`, `flutter analyze --no-fatal-infos`, `flutter test`, and `flutter build apk --release`. The GitHub Actions workflow also builds Android APK, unsigned iOS simulator, Windows and macOS artifacts from the `native-rebuild` branch. The iOS simulator artifact is unsigned and is not an App Store install package.

The web files at the repository root are the separate original website/PWA. They are preserved; this native app lives in `mobile/`.

