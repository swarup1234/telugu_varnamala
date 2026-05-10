# తెలుగు వర్ణమాల · Telugu Varnamala

A Flutter app for kids to learn the Telugu alphabet (వర్ణమాల). It covers all 52 letters — vowels (అచ్చులు) and consonants (హల్లులు) — with audio pronunciation, illustrated word examples, progress tracking, and a quiz mode.

---

## Features

- **Browse letters** — Vowels and consonants displayed in a grid. Tap any letter to open its detail view.
- **Detail view** — Shows the Telugu letter, its romanisation, an SVG illustration, the example word in Telugu and English, and a "Play Sound" button.
- **Auto-play** — Audio plays automatically when you open a letter.
- **Progress tracking** — Letters you've visited are marked with a ⭐ and highlighted in the grid. Progress is saved locally using `shared_preferences`.
- **Quiz mode** — Hear a sound and pick the matching letter from four options. Correct answers trigger a confetti animation.

---

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── letter.dart            # Letter data model
├── screens/
│   ├── home_screen.dart       # Main menu (Vowels / Consonants / Quiz)
│   ├── grid_screen.dart       # Letter grid for a given type
│   ├── detail_screen.dart     # Single letter detail + audio
│   └── quiz_screen.dart       # Quiz mode
├── services/
│   ├── audio_service.dart     # Wraps just_audio for playback
│   └── progress_service.dart  # Saves/reads learned letters via shared_preferences
└── widgets/
    └── letter_card.dart       # Grid tile widget

assets/
├── data/
│   └── letters.json           # All letter data (source of truth)
├── audio/
│   └── *.mp3                  # One audio file per letter
└── images/
    └── *.svg                  # One SVG illustration per letter
```

---

## Letter Data (`assets/data/letters.json`)

Every letter is one JSON object:

```json
{
  "id": "v1",
  "letter": "అ",
  "roman": "A",
  "word_telugu": "అమ్మ",
  "word_english": "Amma",
  "word_meaning": "Mother",
  "audio_file": "a_amma.mp3",
  "image_file": "amma.png",
  "type": "vowel",
  "order": 1
}
```

| Field | Description |
|---|---|
| `id` | Unique identifier (`v1`–`v16` for vowels, `c1`–`c36` for consonants) |
| `letter` | Telugu character |
| `roman` | Romanised pronunciation |
| `word_telugu` | Example word in Telugu script |
| `word_english` | Transliteration of the example word |
| `word_meaning` | English meaning of the example word |
| `audio_file` | Filename in `assets/audio/` |
| `image_file` | Filename in `assets/images/` (referenced as `.svg` at runtime) |
| `type` | `"vowel"` or `"consonant"` |
| `order` | Display order in the grid |

---

## Adding or Editing a Letter

1. **Edit `assets/data/letters.json`** — add or update the JSON entry.
2. **Add the audio file** — place an MP3 named exactly as `audio_file` in `assets/audio/`.
3. **Add the image** — place an SVG named as `image_file` (with `.svg` extension) in `assets/images/`.
4. No code changes needed — the app loads everything from the JSON at runtime.

> The app replaces `.png` → `.svg` when loading images, so always provide SVG files even if `image_file` ends in `.png`.

---

## Recording Audio

A helper script is included to record all letter audio clips using your Mac's microphone:

```bash
bash record_audio.sh
```

Requirements: [SoX](https://sox.sourceforge.net/) installed via Homebrew (`brew install sox`).

The script walks through all 52 letters interactively. For each letter it shows the Telugu character, romanisation, and example word, then records a 3-second clip and saves it to `assets/audio/`. Already-recorded files are skipped automatically.

Controls during recording:
- `Enter` — record
- `s` — skip this letter
- `q` — quit

---

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

Minimum Flutter SDK: `^3.11.5`

---

## Dependencies

| Package | Purpose |
|---|---|
| `just_audio ^0.9.36` | Audio playback |
| `shared_preferences ^2.2.2` | Persist learned-letter progress |
| `confetti ^0.7.0` | Confetti animation on correct quiz answers |
| `flutter_svg ^2.0.10+1` | Render SVG illustrations |

---

## Customisation

**Change the colour theme** — the seed colour is set in `main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
```

**Change the background colour** — each screen uses `const Color(0xFFFFF8E1)` (warm cream). Search for that hex value to update all screens at once.

**Add a new screen** — create a file in `lib/screens/`, then add a navigation button in `home_screen.dart` following the existing `_MenuButton` pattern.

**Reset progress** — progress is stored in `shared_preferences` with keys prefixed `learned_`. Uninstalling the app clears it, or call `SharedPreferences.getInstance()` then `prefs.clear()` programmatically.
