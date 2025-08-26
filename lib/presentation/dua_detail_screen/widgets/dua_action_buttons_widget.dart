import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DuaActionButtonsWidget extends StatefulWidget {
  final Map<String, dynamic> dua;

  const DuaActionButtonsWidget({
    Key? key,
    required this.dua,
  }) : super(key: key);

  @override
  State<DuaActionButtonsWidget> createState() => _DuaActionButtonsWidgetState();
}

class _DuaActionButtonsWidgetState extends State<DuaActionButtonsWidget> {
  bool _isBookmarked = false;

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show confirmation toast
    Fluttertoast.showToast(
      msg: _isBookmarked ? "Added to bookmarks" : "Removed from bookmarks",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      fontSize: 14.sp,
    );
  }

  void _shareContent() {
    final String shareText = _buildShareText();

    // For demonstration, we'll copy to clipboard and show toast
    Clipboard.setData(ClipboardData(text: shareText));

    Fluttertoast.showToast(
      msg: "Dua copied to clipboard for sharing",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: AppTheme.lightTheme.colorScheme.onSecondary,
      fontSize: 14.sp,
    );
  }

  void _copyArabicText() {
    final String arabicText = widget.dua['arabicText'] as String? ?? '';

    if (arabicText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: arabicText));

      // Haptic feedback
      HapticFeedback.selectionClick();

      Fluttertoast.showToast(
        msg: "Arabic text copied to clipboard",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: AppTheme.lightTheme.colorScheme.onTertiary,
        fontSize: 14.sp,
      );
    }
  }

  String _buildShareText() {
    final String title = widget.dua['title'] as String? ?? 'Islamic Dua';
    final String arabicText = widget.dua['arabicText'] as String? ?? '';
    final String transliteration =
        widget.dua['transliteration'] as String? ?? '';
    final String translation = widget.dua['translation'] as String? ?? '';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bookmark Button
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: ElevatedButton.icon(
                onPressed: _toggleBookmark,
                icon: CustomIconWidget(
                  iconName: _isBookmarked ? 'favorite' : 'favorite_border',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(
                  _isBookmarked ? 'Bookmarked' : 'Bookmark',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBookmarked
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),

          // Share Button
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: OutlinedButton.icon(
                onPressed: _shareContent,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'Share',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Copy Arabic Text Button
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: TextButton.icon(
                onPressed: _copyArabicText,
                icon: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
                label: Text(
                  'Copy',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
