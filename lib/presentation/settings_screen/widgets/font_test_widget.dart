import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FontTestWidget extends StatefulWidget {
  const FontTestWidget({Key? key}) : super(key: key);

  @override
  State<FontTestWidget> createState() => _FontTestWidgetState();
}

class _FontTestWidgetState extends State<FontTestWidget> {
  String _selectedFont = 'Uthmanic';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Test'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font Selector
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Font',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ...IndoPakFonts.getAvailableFonts().map((font) {
                      return RadioListTile<String>(
                        title: Text(font['name']!),
                        subtitle: Text(font['description']!),
                        value: font['family']!,
                        groupValue: _selectedFont,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedFont = value;
                            });
                            IndoPakFonts.setPreferredFont(value);
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Test Text Display
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Text with Diacritical Marks',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: SelectableText(
                        IndoPakFonts.getTestText(),
                        style: IndoPakFonts.getArabicTextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                          height: 2.0,
                          fontFamily: _selectedFont,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Individual Font Tests
            ...IndoPakFonts.getAvailableFonts().map((font) {
              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        font['name']!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        font['description']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: SelectableText(
                          IndoPakFonts.getTestText(),
                          style: IndoPakFonts.getArabicTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurface,
                            height: 1.8,
                            fontFamily: font['family'],
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            SizedBox(height: 3.h),
            
            // Instructions
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Choose the Best Font',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildInstructionItem(
                      '1',
                      'Check diacritical marks (fatha, kasra, damma) alignment',
                      'The marks should be clearly visible and properly positioned above/below letters',
                    ),
                    _buildInstructionItem(
                      '2',
                      'Look for consistent letter spacing',
                      'Letters should be evenly spaced without crowding or gaps',
                    ),
                    _buildInstructionItem(
                      '3',
                      'Verify readability at different sizes',
                      'Text should remain clear and legible when zoomed in/out',
                    ),
                    _buildInstructionItem(
                      '4',
                      'Consider authentic Indo-Pakistani style',
                      'Choose the font that best matches traditional Quran copies',
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save the selected font preference
                  IndoPakFonts.setPreferredFont(_selectedFont);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Font preference saved: ${_selectedFont}'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text(
                  'Save Font Preference',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInstructionItem(String number, String title, String description) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Center(
              child: Text(
                number,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 