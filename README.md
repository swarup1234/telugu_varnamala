# తెలుగు వర్ణమాల · Telugu Varnamala

A Flutter app for kids to learn the Telugu alphabet (వర్ణమాల). It covers all 52 letters — vowels (అచ్చులు) and consonants (హల్లులు) — with audio pronunciation, illustrated word examples, progress tracking, and a quiz mode.

---

## Features

- **Browse letters** — Vowels and consonants displayed in a colourful grid. Tap any letter to open its detail view.
- **Swipe navigation** — In the detail view, swipe left/right to move through all letters in order. Audio plays automatically on each swipe.
- **Detail view** — Shows the Telugu letter, its romanisation, an SVG illustration, the example word in Telugu and English, and a "Play Sound" button.
- **Progress tracking** — Letters you've visited are highlighted with a colour gradient and a ⭐ in the grid. A progress bar shows how many letters you've learned. Progress is saved locally using `shared_preferences`.
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
│   ├── grid_screen.dart       # Letter grid with progress bar
│   ├── detail_screen.dart     # Swipeable letter detail + audio
│   └── quiz_screen.dart       # Quiz mode
├── services/
│   ├── audio_service.dart     # Wraps just_audio for playback
│   └── progress_service.dart  # Saves/reads learned letters via shared_preferences
└── widgets/
    └── letter_card.dart       # Grid tile widget (colour gradient per letter)

assets/
├── data/
│   └── letters.json           # All letter data (source of truth)
├── audio/
│   └── *.mp3                  # One audio file per letter (not tracked in git)
├── images/
│   └── *.svg                  # One SVG illustration per letter (not tracked in git)
└── app_icon.png               # Source icon used to generate all platform launcher icons
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

> `assets/audio/` and `assets/images/` are excluded from git (see `.gitignore`). If a letter's SVG is missing the detail screen will show a placeholder icon — add the file to `assets/images/` to fix it.

---

## App Icon

The launcher icon (`assets/app_icon.png`) is a 1024×1024 PNG with an orange gradient background and the white Telugu letter **అ**. It is generated using `flutter_launcher_icons` and produces all required sizes for Android and iOS automatically.

To regenerate icons after changing `assets/app_icon.png`:

```bash
dart run flutter_launcher_icons
```

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

# Run release build on connected device
flutter run --release
```

Minimum Flutter SDK: `^3.11.5`

---

## Testing on Your Phone

**USB (recommended for development)**
1. Enable Developer Options on your phone: Settings → About phone → tap "Build number" 7 times.
2. Enable USB Debugging: Settings → Developer Options → USB Debugging.
3. Connect via USB, then run `flutter run`.

**APK install (for sharing)**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```
Transfer the APK to your phone and install it. Allow "Install from unknown sources" when prompted.

---

## Building for Release (Android)

### 1. Create a keystore (one-time)
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Create `android/key.properties`
```
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

> `android/key.properties` and `*.jks` files are excluded from git via `android/.gitignore`. Never commit them.

### 3. Build the release bundle
```bash
flutter build appbundle
# Output: build/app/outputs/bundle/release/app-release.aab
```

### 4. Upload to Play Store
1. Go to [play.google.com/console](https://play.google.com/console) and create a new app.
2. Fill in the store listing (title, description, screenshots, icon).
3. Go to **Production → Create new release → Upload** the `.aab` file.
4. Complete the content rating questionnaire and submit for review.

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

**Add a new screen** — create a file in `lib/screens/`, then add a navigation card in `home_screen.dart` following the existing `_MenuCard` pattern.

**Reset progress** — progress is stored in `shared_preferences` with keys prefixed `learned_`. Uninstalling the app clears it, or call `SharedPreferences.getInstance()` then `prefs.clear()` programmatically.
