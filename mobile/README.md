# LEARNERS DIC. — Native application

Flutter application targeting Android and iOS. The original website remains on the repository's main branch; this application is developed on `native-rebuild`.

## Implemented in this build
- Native Flutter navigation with Dictionary, Translate, Learn and Saved sections.
- English word lookup through the Free Dictionary API (dictionaryapi.dev), displaying returned phonetics, meanings, parts of speech, examples, synonyms, antonyms and origin when supplied.
- Text translation through MyMemory's public translation endpoint for the language pairs exposed by the service.
- Copy controls and a locally stored recent-translation history (up to 20 entries).
- Device text-to-speech for reading words and translations.
- A small starter vocabulary quiz.
- Saved English words stored locally with shared_preferences.

## Important coverage limits
This is a working early application build, not a complete multilingual dictionary or full language-learning platform. English is the only connected dictionary collection. French, Spanish, Yorùbá, Igbo and Hausa are selectable in the interface but do not yet have searchable dictionary databases. Translation availability and quality depend on MyMemory's supported language pairs and service limits. Machine translations must not be treated as authoritative. The starter quiz is not a complete curriculum. New dictionary lookups and translations require internet access; saved word names are stored locally, but full dictionary entries are not yet cached offline.

## Build
From this directory:
`flutter pub get`
`flutter analyze`
`flutter test`
`flutter run`

iOS builds require macOS and Xcode. A simulator build is not an installable physical-iPhone release. Physical-device distribution requires Apple signing and provisioning; App Store/TestFlight distribution requires Apple Developer Program membership.

## Data and privacy
Dictionary lookups send the requested English word to dictionaryapi.dev. Translation text is sent to MyMemory. Users should avoid submitting confidential or sensitive text to the translation service. Review the services' terms, privacy policies, attribution and licensing before public release.
