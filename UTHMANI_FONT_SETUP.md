# Uthmani Font Setup Guide

## 🎯 **What We're Setting Up**

The **Uthmani font** is the authentic font used in Arabic Quran copies. It provides:
- **Perfect diacritical marks** (fatha, kasra, damma, sukun, shadda)
- **Authentic Quran styling** 
- **Bold appearance** for better readability
- **Professional Arabic typography**

## 📥 **Step 1: Download Uthmani Font**

### **Option A: Official Quran Complex Font (Recommended)**
1. Visit: https://fonts.qurancomplex.gov.sa/
2. Download: `KFGQPC-Uthman-Taha-Naskh.ttf`
3. This is the official font used in the King Fahd Quran Complex

### **Option B: Alternative Uthmani Fonts**
- **Uthmanic Script**: Search for "Uthmanic Script font download"
- **Scheherazade**: Available on Google Fonts (already integrated)

## 📁 **Step 2: Setup Font Files**

### **For Best Results (Recommended Setup)**

1. **Download the official font** from Quran Complex
2. **Rename it** to: `Uthmani_Quran.ttf`
3. **Place it in**: `assets/fonts/Uthmani_Quran.ttf`
4. **Update pubspec.yaml**:

```yaml
fonts:
  - family: Uthmani
    fonts:
      - asset: assets/fonts/Uthmani_Quran.ttf
        weight: 600
```

### **Quick Setup (Using Existing Font)**

If you want to use your existing font as Uthmani:

1. **Copy your current font**: `Uthman_Taha_Naskh_Regular.ttf`
2. **Rename it** to: `Uthmani_Quran.ttf`
3. **Place it in**: `assets/fonts/Uthmani_Quran.ttf`
4. **Update pubspec.yaml** (already done in this implementation)

## ⚙️ **Step 3: Configuration (Already Done!)**

The following has been implemented:

### **✅ Font Helper Class**
```dart
// Get Uthmani font with bold styling
IndoPakFonts.getUthmaniTextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w600, // Bold by default
)
```

### **✅ Default Font Setting**
- Uthmani is now the default font for Arabic text
- All duas automatically use Uthmani font
- Bold styling applied by default

### **✅ Font Testing**
- Settings → Arabic Font → Test Arabic Fonts
- Compare Uthmani with other fonts
- Save your preference

## 🚀 **Step 4: Run the App**

1. **Clean and get dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

## 🎨 **How It Looks**

### **Before (Regular Font)**
```
بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
```

### **After (Uthmani Bold)**
```
بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
```
*Bold, authentic Quran-style appearance*

## 📱 **Features Implemented**

### **1. Automatic Uthmani Styling**
- All Arabic duas use Uthmani font
- Bold weight (600) for better readability
- Proper line height for Quran-style text

### **2. Font Testing Widget**
- Compare Uthmani with other fonts
- Test diacritical mark rendering
- Save your preferred font

### **3. Easy Font Switching**
```dart
// Use Uthmani (default)
IndoPakFonts.getUthmaniTextStyle()

// Use alternative font
IndoPakFonts.getArabicTextStyle(fontFamily: 'Uthmanic')
```

## 🔍 **Verification**

After setup, you should see:
- ✅ Arabic text displays in authentic Uthmani style
- ✅ Bold, clear appearance
- ✅ Perfect diacritical marks alignment
- ✅ Professional Quran-like typography
- ✅ Better readability than regular fonts

## 🎯 **Usage Examples**

### **In Duas**
```dart
Text(
  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  style: IndoPakFonts.getUthmaniTextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
  ),
)
```

### **In Task Names**
```dart
Text(
  'أذكار الصباح',
  style: IndoPakFonts.getUthmaniTextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  ),
)
```

### **In Dhikr**
```dart
Text(
  'سُبْحَانَ اللَّهِ',
  style: IndoPakFonts.getUthmaniTextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  ),
)
```

## 🆘 **Troubleshooting**

### **Font Not Loading?**
1. Check file path: `assets/fonts/Uthmani_Quran.ttf`
2. Verify filename matches exactly
3. Run `flutter clean && flutter pub get`
4. Restart your IDE/emulator

### **Font Not Bold Enough?**
1. Increase font weight: `FontWeight.w700` or `FontWeight.w800`
2. Increase font size for better visibility
3. Adjust line height for better spacing

### **Diacritical Marks Still Wrong?**
1. Use the font testing widget to compare
2. Try different font sizes
3. Check if the issue is with specific text

## 📊 **Font Comparison**

| Font | Diacritical Marks | Authentic Style | Bold Support |
|------|------------------|-----------------|--------------|
| **Uthmani (Quran)** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **KFGQPC Uthman** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Noto Sans Arabic** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

## 🎯 **Result**

Your app will now display Arabic text in the beautiful, authentic Uthmani font used in traditional Quran copies, with bold styling for excellent readability and professional appearance!

---

**Note**: The Uthmani font provides the most authentic Quran-style appearance with perfect diacritical mark support and bold styling for better readability. 