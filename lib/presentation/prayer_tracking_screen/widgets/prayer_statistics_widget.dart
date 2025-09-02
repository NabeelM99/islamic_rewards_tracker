import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/prayer_model.dart';
import '../../../theme/app_theme.dart';

class PrayerStatisticsWidget extends StatelessWidget {
  final PrayerStatistics? statistics;

  const PrayerStatisticsWidget({
    super.key,
    this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (statistics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_rounded,
              size: 15.w,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Statistics Available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Start tracking your prayers to see statistics',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(3.w),
      children: [
        // Overall Statistics
        _OverallStatsCard(statistics: statistics!),
        
        SizedBox(height: 2.h),
        
        // Prayer Type Statistics
        _PrayerTypeStatsCard(statistics: statistics!),
        
        SizedBox(height: 2.h),
        
        // Monthly Statistics
        _MonthlyStatsCard(statistics: statistics!),
      ],
    );
  }
}

class _OverallStatsCard extends StatelessWidget {
  final PrayerStatistics statistics;

  const _OverallStatsCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  value: '${statistics.completedPrayers}',
                  color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.schedule_rounded,
                  label: 'Missed',
                  value: '${statistics.missedPrayers}',
                  color: theme.colorScheme.error,
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.replay_rounded,
                  label: 'Qaza',
                  value: '${statistics.qazaPrayers}',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Completion Rate
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completion Rate',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${statistics.completionRate.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 1.h),
              
              LinearProgressIndicator(
                value: (statistics.completionRate / 100).clamp(0.0, 1.0),
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerTypeStatsCard extends StatelessWidget {
  final PrayerStatistics statistics;

  const _PrayerTypeStatsCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prayer Type Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          ...PrayerType.values.map((type) {
            final count = statistics.prayerTypeStats[type] ?? 0;
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: _getPrayerTypeColor(theme, type),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getPrayerTypeIcon(type),
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                  
                  SizedBox(width: 3.w),
                  
                  Expanded(
                    child: Text(
                      _getPrayerTypeDisplayName(type),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  Text(
                    '$count',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getPrayerTypeColor(ThemeData theme, PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Colors.orange;
      case PrayerType.dhuhr:
        return Colors.blue;
      case PrayerType.asr:
        return Colors.green;
      case PrayerType.maghrib:
        return Colors.purple;
      case PrayerType.isha:
        return Colors.indigo;
    }
  }

  IconData _getPrayerTypeIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.wb_sunny_rounded;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.wb_sunny_rounded;
      case PrayerType.maghrib:
        return Icons.nights_stay_rounded;
      case PrayerType.isha:
        return Icons.nights_stay_outlined;
    }
  }

  String _getPrayerTypeDisplayName(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }
}

class _MonthlyStatsCard extends StatelessWidget {
  final PrayerStatistics statistics;

  const _MonthlyStatsCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedMonths = statistics.monthlyStats.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          if (sortedMonths.isEmpty)
            Center(
              child: Text(
                'No monthly data available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...sortedMonths.take(6).map((monthKey) {
              final count = statistics.monthlyStats[monthKey] ?? 0;
              final monthName = _formatMonthKey(monthKey);
              
              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                    
                    SizedBox(width: 3.w),
                    
                    Expanded(
                      child: Text(
                        monthName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    Text(
                      '$count prayers',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  String _formatMonthKey(String monthKey) {
    try {
      final parts = monthKey.split('-');
      if (parts.length == 2) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final date = DateTime(year, month);
        return '${_getMonthName(month)} $year';
      }
    } catch (e) {
      // Handle parsing errors
    }
    return monthKey;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 6.w,
          ),
        ),
        
        SizedBox(height: 1.h),
        
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 