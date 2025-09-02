# Indo-Pakistani Font Setup Guide

This guide will help you set up authentic Indo-Pakistani (Uthmanic) fonts for Arabic text in your Islamic Rewards Tracker app.

## 🎯 What We're Setting Up

- **KFGQPC Uthman Taha Naskh** - Primary Indo-Pakistani font
- **Scheherazade** - Alternative Indo-Pakistani font
- Automatic font application to all Arabic text

## 📥 Step 1: Download Font Files

### Option A: KFGQPC Uthman Taha Naskh (Recommended)
1. Visit: https://fonts.qurancomplex.gov.sa/
2. Download: `KFGQPC-Uthman-Taha-Naskh.ttf`
3. Download: `KFGQPC-Uthman-Taha-Naskh-Bold.ttf`

### Option B: Alternative Sources
- **Uthmanic Script**: Search for "Uthmanic Script font download"
- **Scheherazade**: Available on Google Fonts or GitHub

## 📁 Step 2: Place Font Files

1. Copy your downloaded `.ttf` files
2. Paste them into: `assets/fonts/` folder
3. Ensure the filenames match exactly:
   ```
   assets/fonts/
   ├── Uthman_Taha_Naskh_Regular.ttf  ← Your font file
   ```

**Note**: The primary font "Uthman_Taha_Naskh_Regular.ttf" is already configured in your project.

## ⚙️ Step 3: Configuration (Already Done!)

The following files have already been updated:
- ✅ `pubspec.yaml` - Font declarations added
- ✅ `lib/theme/app_theme.dart` - Font helper class created
- ✅ `lib/presentation/dua_detail_screen/widgets/dua_content_widget.dart` - Font applied

## 🚀 Step 4: Run the App

1. **Clean and get dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

## 🎨 How to Use the Fonts

### In Code:
```dart
// Primary Indo-Pakistani font
Text(
  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  style: IndoPakFonts.getArabicTextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  ),
)

// Alternative font
Text(
  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  style: IndoPakFonts.getAlternativeArabicTextStyle(
    fontSize: 20.0,
  ),
)
```

### Automatic Application:
- All Arabic text in duas will automatically use the Indo-Pakistani font
- New duas added through `addDuaToCategoryWithFormatting()` will be automatically formatted

## 🔍 Verification

After setup, you should see:
- ✅ Arabic text displays in authentic Indo-Pakistani style
- ✅ Distinctive calligraphic features (upward-curving ي, elongated ك, etc.)
- ✅ Proper diacritical marks and spacing
- ✅ Eastern Arabic numerals (١, ٢, ٣) instead of Western (1, 2, 3)

## 🆘 Troubleshooting

### Font Not Loading?
1. Check file paths in `assets/fonts/`
2. Verify filenames match exactly
3. Run `flutter clean` and `flutter pub get`
4. Restart your IDE/emulator

### Font Looks Wrong?
1. Ensure you're using the correct font files
2. Check that `IndoPakFonts.getArabicTextStyle()` is being called
3. Verify the font family names in `pubspec.yaml`

## 📱 Result

Your app will now display Arabic text in the beautiful, authentic Indo-Pakistani font style used in traditional Quran copies from Pakistan, India, and surrounding regions!

---

**Note**: If you can't find the exact fonts mentioned, any authentic Indo-Pakistani/Uthmanic font will work. Just update the filenames in `pubspec.yaml` to match your downloaded files. 