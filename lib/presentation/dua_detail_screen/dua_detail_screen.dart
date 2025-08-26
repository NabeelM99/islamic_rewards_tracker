import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dua_action_buttons_widget.dart';
import './widgets/dua_content_widget.dart';
import './widgets/dua_header_widget.dart';

class DuaDetailScreen extends StatefulWidget {
  const DuaDetailScreen({Key? key}) : super(key: key);

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  Map<String, dynamic>? selectedDua;

  // Mock dua data - in real app this would come from navigation arguments or database
  final List<Map<String, dynamic>> mockDuas = [
    {
      "id": 1,
      "title": "Morning Remembrance",
      "arabicTitle": "أذكار الصباح",
      "category": "Morning Adhkar",
      "arabicText":
          "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ",
      "transliteration":
          "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilayka an-nushur",
      "translation":
          "O Allah, by You we enter the morning and by You we enter the evening. By You we live and by You we die, and to You is the resurrection.",
      "reference": "Abu Dawud 5068",
      "benefits": "Protection and blessing for the day"
    },
    {
      "id": 2,
      "title": "Evening Remembrance",
      "arabicTitle": "أذكار المساء",
      "category": "Evening Adhkar",
      "arabicText":
          "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ",
      "transliteration":
          "Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilayka al-masir",
      "translation":
          "O Allah, by You we enter the evening and by You we enter the morning. By You we live and by You we die, and to You is our return.",
      "reference": "Abu Dawud 5068",
      "benefits": "Protection and peace for the night"
    },
    {
      "id": 3,
      "title": "Seeking Forgiveness",
      "arabicTitle": "الاستغفار",
      "category": "Istighfar",
      "arabicText":
          "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ",
      "transliteration":
          "Astaghfiru Allah al-azeem alladhi la ilaha illa huwa al-hayy al-qayyum wa atubu ilayh",
      "translation":
          "I seek forgiveness from Allah the Mighty, whom there is no god but He, the Living, the Eternal, and I repent to Him.",
      "reference": "Abu Dawud 1517",
      "benefits": "Forgiveness of sins and spiritual purification"
    },
    {
      "id": 4,
      "title": "Before Eating",
      "arabicTitle": "دعاء قبل الطعام",
      "category": "Daily Duas",
      "arabicText": "بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ",
      "transliteration": "Bismillahi wa ala barakatillah",
      "translation": "In the name of Allah and with the blessing of Allah.",
      "reference": "Abu Dawud 3767",
      "benefits": "Blessing in sustenance and gratitude to Allah"
    },
    {
      "id": 5,
      "title": "After Eating",
      "arabicTitle": "دعاء بعد الطعام",
      "category": "Daily Duas",
      "arabicText":
          "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ",
      "transliteration":
          "Alhamdu lillahi alladhi at'amana wa saqana wa ja'alana muslimeen",
      "translation":
          "Praise be to Allah who has fed us and given us drink and made us Muslims.",
      "reference": "Abu Dawud 3850",
      "benefits": "Gratitude and acknowledgment of Allah's blessings"
    }
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get dua from navigation arguments or use first dua as default
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args['dua'] != null) {
      selectedDua = args['dua'] as Map<String, dynamic>;
    } else {
      // Default to first dua if no arguments provided
      selectedDua = mockDuas.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDua == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dua Detail'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          selectedDua!['title'] as String? ?? 'Dua Detail',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality - same as in action buttons
              final String shareText = _buildShareText();
              // In real app, this would use platform share
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Share functionality would open here'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dua Header
              DuaHeaderWidget(dua: selectedDua!),

              SizedBox(height: 3.h),

              // Dua Content
              DuaContentWidget(dua: selectedDua!),

              SizedBox(height: 3.h),

              // Additional Information Card
              if (selectedDua!['reference'] != null ||
                  selectedDua!['benefits'] != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedDua!['reference'] != null) ...[
                        Text(
                          'Reference',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          selectedDua!['reference'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        if (selectedDua!['benefits'] != null)
                          SizedBox(height: 2.h),
                      ],
                      if (selectedDua!['benefits'] != null) ...[
                        Text(
                          'Benefits',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          selectedDua!['benefits'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: DuaActionButtonsWidget(dua: selectedDua!),
        ),
      ),
    );
  }

  String _buildShareText() {
    final String title = selectedDua!['title'] as String? ?? 'Islamic Dua';
    final String arabicText = selectedDua!['arabicText'] as String? ?? '';
    final String transliteration =
        selectedDua!['transliteration'] as String? ?? '';
    final String translation = selectedDua!['translation'] as String? ?? '';

    String shareContent = '$title\n\n';

    if (arabicText.isNotEmpty) {
      shareContent += 'Arabic:\n$arabicText\n\n';
    }

    if (transliteration.isNotEmpty) {
      shareContent += 'Transliteration:\n$transliteration\n\n';
    }

    if (translation.isNotEmpty) {
      shareContent += 'Translation:\n$translation\n\n';
    }

    shareContent += 'Shared from Islamic Rewards Tracker';

    return shareContent;
  }
}
