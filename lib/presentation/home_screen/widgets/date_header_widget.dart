import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class DateHeaderWidget extends StatefulWidget {
  final DateTime currentDate;
  final String islamicGreeting;
  final Function(String) onNavigate;
  final VoidCallback? onReset;

  const DateHeaderWidget({
    Key? key,
    required this.currentDate,
    required this.islamicGreeting,
    required this.onNavigate,
    this.onReset,
  }) : super(key: key);

  @override
  State<DateHeaderWidget> createState() => _DateHeaderWidgetState();
}

class _DateHeaderWidgetState extends State<DateHeaderWidget> {
  // Cache for expensive calculations
  late String _hijriDate;
  late String _gregorianDate;
  late String _resetInfo;
  
  // Static data for better performance
  static const List<String> _hijriMonths = [
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
  
  static const List<String> _gregorianMonths = [
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
  
  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _updateCachedValues();
  }

  @override
  void didUpdateWidget(DateHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if date changed
    if (oldWidget.currentDate != widget.currentDate) {
      _updateCachedValues();
    }
  }

  void _updateCachedValues() {
    _hijriDate = _getHijriDate();
    _gregorianDate = _getGregorianDate();
    _resetInfo = _getResetInfo();
  }

  String _getHijriDate() {
    // Mock Hijri date calculation - in real app would use proper Islamic calendar
    final hijriYear = widget.currentDate.year - 579;
    final hijriMonth = _hijriMonths[(widget.currentDate.month - 1) % 12];
    return '${widget.currentDate.day} $hijriMonth $hijriYear AH';
  }

  String _getGregorianDate() {
    final weekday = _weekdays[widget.currentDate.weekday - 1];
    final month = _gregorianMonths[widget.currentDate.month - 1];
    return '$weekday, ${widget.currentDate.day} $month ${widget.currentDate.year}';
  }

  String _getResetInfo() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentDay = DateTime(widget.currentDate.year, widget.currentDate.month, widget.currentDate.day);
    
    if (today.isAtSameMomentAs(currentDay)) {
      return 'Tasks reset at midnight';
    } else {
      return 'Tasks reset for new day';
    }
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
                    widget.islamicGreeting,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Tasbih Counter Button
                IconButton(
                  onPressed: () {
                    print('Tasbih Counter button pressed');
                    widget.onNavigate(AppRoutes.tasbihCounter);
                  },
                  icon: Icon(
                    Icons.radio_button_checked_rounded,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 2.w),
                // Navigation Dropdown
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                  onSelected: (route) {
                    print('Dropdown item selected: $route');
                    if (route == 'reset') {
                      widget.onReset?.call();
                    } else {
                      widget.onNavigate(route);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: AppRoutes.prayerTracking,
                      child: Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('Prayer Tracking'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.duas,
                      child: Row(
                        children: [
                          Icon(Icons.menu_book_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('Duas'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'favorites',
                      child: Row(
                        children: [
                          Icon(Icons.favorite_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('Favorites'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.history,
                      child: Row(
                        children: [
                          Icon(Icons.history_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('History'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'reset',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('Reset Today\'s Tasks'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: AppRoutes.settings,
                      child: Row(
                        children: [
                          Icon(Icons.settings_rounded, size: 4.w),
                          SizedBox(width: 2.w),
                          const Text('Settings'),
                        ],
                      ),
                    ),
                  ],
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
                        _hijriDate,
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
                        _gregorianDate,
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
            SizedBox(height: 1.h),
            // Reset Info
            Row(
              children: [
                Icon(
                  Icons.refresh_rounded,
                  color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
                  size: 3.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  _resetInfo,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
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
