# Islamic Rewards Tracker

A comprehensive Flutter application for tracking Islamic activities, prayers, duas, and daily spiritual tasks with authentic Indo-Pakistani Arabic font support.

## 🌟 Features

- **Prayer Tracking**: Track daily prayers with visual progress indicators
- **Dua Collection**: Extensive collection of authentic duas with proper Arabic text
- **Tasbih Counter**: Digital counter for dhikr and remembrance
- **Task Management**: Create and track daily Islamic tasks
- **History & Analytics**: View progress over time with detailed statistics
- **Authentic Typography**: Indo-Pakistani (Uthmanic) font for Arabic text

## 🎨 Indo-Pakistani Font Support

This app features authentic Indo-Pakistani (Uthmanic) fonts for Arabic text, providing:
- Traditional calligraphic styling used in Quran copies from Pakistan/India
- Proper diacritical marks (harakat) for correct pronunciation
- Eastern Arabic numerals (١, ٢, ٣) instead of Western (1, 2, 3)
- Automatic font conversion for new Arabic text

### Font Setup
See `FONT_SETUP_README.md` for detailed instructions on setting up the Indo-Pakistani fonts.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd islamic_rewards_tracker-main
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Indo-Pakistani fonts** (Optional but recommended)
   - Follow the instructions in `FONT_SETUP_README.md`
   - Download and place font files in `assets/fonts/`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── core/           # Core models, services, and utilities
├── data/           # Data repositories and sources
├── presentation/   # UI screens and widgets
├── theme/          # App theming and styling
└── widgets/        # Reusable UI components
```

## 🔧 Key Components

- **DuasRepository**: Manages dua data with automatic Indo-Pakistani font conversion
- **IndoPakFonts**: Helper class for applying authentic Arabic typography
- **AppTheme**: Comprehensive theming system with Arabic text optimization
- **Responsive Design**: Built with Sizer package for cross-device compatibility

## 📊 Features in Detail

### Prayer Tracking
- Track 5 daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Qaza prayer tracking
- Sunnah prayer support
- Visual progress indicators

### Dua Collection
- Morning and Evening Adhkar
- Daily supplications
- Search and filter functionality
- Bookmarking system

### Task Management
- Create custom Islamic tasks
- Set daily targets
- Track completion progress
- Arabic and English task names


## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Authentic Indo-Pakistani fonts from Quran Complex
- Islamic scholars and hadith collections
- Flutter community for excellent tooling
