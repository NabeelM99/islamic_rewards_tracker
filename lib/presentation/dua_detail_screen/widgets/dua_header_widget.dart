import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DuaHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> dua;

  const DuaHeaderWidget({
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
          // English Title
          Text(
            dua['title'] as String? ?? 'Dua',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 2.h),

          // Arabic Title (if available)
          if (dua['arabicTitle'] != null &&
              (dua['arabicTitle'] as String).isNotEmpty)
            Container(
              width: double.infinity,
              child: Text(
                dua['arabicTitle'] as String,
                style: AppTheme.arabicTextTheme(isLight: true)
                    .headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      height: 1.8,
                    ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
        ],
      ),
    );
  }
}
