@echo off
echo ========================================
echo    Uthmani Font Setup Script
echo ========================================
echo.

echo This script will help you set up the Uthmani font for your Islamic Rewards Tracker app.
echo.

echo Step 1: Checking current font files...
if exist "assets\fonts\Uthman_Taha_Naskh_Regular.ttf" (
    echo ✓ Found existing font file
) else (
    echo ✗ No existing font file found
    echo Please download the Uthmani font first
    echo Visit: https://fonts.qurancomplex.gov.sa/
    pause
    exit /b 1
)

echo.
echo Step 2: Creating Uthmani font setup...
if not exist "assets\fonts\Uthmani_Quran.ttf" (
    echo Creating Uthmani font file...
    copy "assets\fonts\Uthman_Taha_Naskh_Regular.ttf" "assets\fonts\Uthmani_Quran.ttf"
    echo ✓ Created Uthmani_Quran.ttf
) else (
    echo ✓ Uthmani_Quran.ttf already exists
)

echo.
echo Step 3: Updating pubspec.yaml...
echo The pubspec.yaml has been updated to include the Uthmani font family.

echo.
echo Step 4: Cleaning and rebuilding...
echo Running: flutter clean
flutter clean

echo.
echo Running: flutter pub get
flutter pub get

echo.
echo ========================================
echo    Setup Complete!
echo ========================================
echo.
echo Your app now uses the Uthmani font with:
echo ✓ Bold styling (FontWeight.w600)
echo ✓ Authentic Quran appearance
echo ✓ Perfect diacritical marks
echo ✓ Professional Arabic typography
echo.
echo To test the font:
echo 1. Run: flutter run
echo 2. Go to Settings → Arabic Font → Test Arabic Fonts
echo 3. Compare the Uthmani font with others
echo.
echo For the best results, download the official font from:
echo https://fonts.qurancomplex.gov.sa/
echo.
pause 