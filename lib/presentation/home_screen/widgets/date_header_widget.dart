import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class DateHeaderWidget extends StatelessWidget {
  final DateTime currentDate;
  final String islamicGreeting;
  final Function(String) onNavigate;

  const DateHeaderWidget({
    Key? key,
    required this.currentDate,
    required this.islamicGreeting,
    required this.onNavigate,
  }) : super(key: key);

  String _getHijriDate() {
    // Mock Hijri date calculation - in real app would use proper Islamic calendar
    final hijriYear = currentDate.year - 579;
    final hijriMonths = [
      'Muharram',
      'Safar',
      'Rabi\' al-awwal',
      'Rabi\' al-thani',
      'Jumada al-awwal',
      'Jumada al-thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah'
    ];
    final hijriMonth = hijriMonths[(currentDate.month - 1) % 12];
    return '${currentDate.day} $hijriMonth $hijriYear AH';
  }

  String _getGregorianDate() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final weekday = weekdays[currentDate.weekday - 1];
    final month = months[currentDate.month - 1];
    return '$weekday, ${currentDate.day} $month ${currentDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Islamic Greeting and Navigation
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'wb_sunny',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    islamicGreeting,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Navigation Dropdown
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                  onSelected: (route) {
                    print('Dropdown item selected: $route');
                    onNavigate(route);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: AppRoutes.tasbihCounter,
                      child: Row(
                        children: [
                          Icon(Icons.radio_button_checked_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          Text('Tasbih Counter'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.prayerTracking,
                      child: Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          Text('Prayer Tracking'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.duas,
                      child: Row(
                        children: [
                          Icon(Icons.menu_book_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          Text('Duas'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.history,
                      child: Row(
                        children: [
                          Icon(Icons.history_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          Text('History'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.settings,
                      child: Row(
                        children: [
                          Icon(Icons.settings_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
                // Test button for debugging
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: () {
                    print('Test button pressed');
                    onNavigate(AppRoutes.tasbihCounter);
                  },
                                       icon: Icon(
                       Icons.science,
                       color: AppTheme.lightTheme.colorScheme.onPrimary,
                       size: 5.w,
                     ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Date Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hijri Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hijri Date',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getHijriDate(),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.3),
                ),
                SizedBox(width: 4.w),
                // Gregorian Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getGregorianDate(),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
