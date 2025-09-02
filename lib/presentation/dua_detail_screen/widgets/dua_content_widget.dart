import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DuaContentWidget extends StatelessWidget {
  final Map<String, dynamic> dua;

  const DuaContentWidget({
    Key? key,
    required this.dua,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arabic Text Section
          if (dua['arabic'] != null &&
              (dua['arabic'] as String).isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: _buildArabicTextWidget(),
            ),
            SizedBox(height: 3.h),
          ],

          // Transliteration Section
          if (dua['transliteration'] != null &&
              (dua['transliteration'] as String).isNotEmpty) ...[
            Text(
              'Transliteration',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                dua['transliteration'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.6,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // English Translation Section
          if (dua['translation'] != null &&
              (dua['translation'] as String).isNotEmpty) ...[
            Text(
              'Translation',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                dua['translation'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.7,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArabicTextWidget() {
    final String arabicText = dua['arabic'] as String;
    final int duaId = dua['id'] as int? ?? 0;
    
    // Check if this is the Istikhara dua (ID 111) and contains the instruction text
    if (duaId == 111 && arabicText.contains('\n(Mention the matter by name)\n')) {
      // Use RichText for Istikhara dua with smaller instruction text
      return _buildIstikharaRichText(arabicText);
    } else {
      // Use regular SelectableText for other duas
      return SelectableText(
        arabicText,
        style: IndoPakFonts.getUthmaniTextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
          height: 2.0,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      );
    }
  }

  Widget _buildIstikharaRichText(String arabicText) {
    // Split the text to find the instruction part
    final parts = arabicText.split('\n(Mention the matter by name)\n');
    
    if (parts.length == 2) {
      // We have the instruction text, so use RichText
      return SelectableText.rich(
        TextSpan(
          style: IndoPakFonts.getUthmaniTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            height: 2.0,
          ),
          children: [
            // First part of Arabic text
            TextSpan(text: parts[0]),
            
            // Line break
            TextSpan(text: '\n'),
            
            // Instruction text with smaller font
            TextSpan(
              text: '(Mention the matter by name)',
              style: TextStyle(
                fontSize: 12.sp, // Much smaller font
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            // Line break
            TextSpan(text: '\n'),
            
            // Second part of Arabic text
            TextSpan(text: parts[1]),
          ],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      );
    } else {
      // Fallback to regular text if splitting didn't work
      return SelectableText(
        arabicText,
        style: IndoPakFonts.getUthmaniTextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
          height: 2.0,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      );
    }
  }
}
