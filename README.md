# LEXICON — Language, with depth.

LEXICON is a free, mobile-first language companion built around two experiences: a multilingual word desk and practical daily language lessons.

## Languages in this first learning release

- English
- French
- Spanish
- Yorùbá
- Igbo
- Hausa

## What works in this version

### Dictionary
- Choose one of the six languages and search its starter glossary.
- English searches not found in the starter list can use the Free Dictionary API when online.
- View introductory meanings and example sentences.
- Use the device's speech synthesis to hear a word or lesson phrase where a suitable voice is installed.
- Save words locally on the device.

### Daily learning
- A four-month (16-week) curriculum roadmap for each of the six launch languages. The current interactive lesson content remains a seven-day prototype while the full daily units are developed and reviewed.
- Each lesson includes vocabulary, a useful phrase, a writing prompt and a model answer.
- Learners can save their writing, mark a day complete and track progress locally.
- There are no subscriptions, paid tiers, payment screens or locked lessons.

## Important language-data note

This is an initial learning release, not a complete dictionary or a promise of fluency in seven days. The non-English dictionary currently contains a small, curated starter glossary and the learning courses are introductory. Language varieties, dialects, tone marks, spelling conventions and forms of address matter, particularly in Yorùbá, Igbo and Hausa. The content should be reviewed and expanded with qualified speakers and reliable references before being treated as comprehensive.

English live lookup uses the public Free Dictionary API. It requires an internet connection. The included starter vocabulary, lesson content, saved words and learning progress are available in the browser; saved data is stored on the current device.

## Run the app

Open `index.html` in a modern browser, or publish the repository using GitHub Pages. An internet connection is needed for the live English dictionary lookup and optional web fonts. Browser speech playback depends on voices available on the device.

## Project files

- `index.html` — application structure and navigation
- `style.css` — responsive editorial visual design
- `script.js` — dictionary search, starter glossaries, saved words and progress handling
- `lessons.js` — current seven-day interactive starter units
- `curriculum.js` — 16-week course progression and weekly study routine
- `manifest.json`, `service-worker.js`, `icon.svg` — installable PWA shell and basic offline app-shell caching

## Next development priorities

1. Review all language examples with native or qualified speakers.
2. Expand each language dictionary with licensed, attributed data.
3. Add audio recorded by speakers, pronunciation guides and dialect notes.
4. Add more levels, listening exercises, spaced review and offline language packs.
5. Complete and review all 80 study days per language, including listening, speaking, reading, writing and cumulative assessment.
6. Test PWA installation and offline behaviour on Android, Windows and iOS browsers. A native Android/iOS app would be a separate later project.

LEXICON is intended to remain free to learn.