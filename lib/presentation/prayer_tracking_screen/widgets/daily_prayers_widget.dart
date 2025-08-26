import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/prayer_model.dart';
import '../../../theme/app_theme.dart';

class DailyPrayersWidget extends StatelessWidget {
  final List<PrayerModel> prayers;
  final Function(String, PrayerStatus, {String? notes}) onPrayerStatusUpdated;
  final Function(String) onPrayerMarkedAsQaza;

  const DailyPrayersWidget({
    super.key,
    required this.prayers,
    required this.onPrayerStatusUpdated,
    required this.onPrayerMarkedAsQaza,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (prayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 15.w,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: 3.h),
            Text(
              'No prayers for this date',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(3.w),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        return _PrayerCard(
          prayer: prayer,
          onStatusUpdated: onPrayerStatusUpdated,
          onMarkedAsQaza: onPrayerMarkedAsQaza,
        );
      },
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final Function(String, PrayerStatus, {String? notes}) onStatusUpdated;
  final Function(String) onMarkedAsQaza;

  const _PrayerCard({
    required this.prayer,
    required this.onStatusUpdated,
    required this.onMarkedAsQaza,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
        children: [
          // Prayer Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getStatusColor(theme, prayer.status).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Prayer Icon
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: _getStatusColor(theme, prayer.status),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getPrayerIcon(prayer.type),
                    color: theme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                ),
                
                SizedBox(width: 4.w),
                
                // Prayer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (prayer.arabicName.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          prayer.arabicName,
                          style: AppTheme.arabicTextTheme(
                            isLight: theme.brightness == Brightness.light
                          ).bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(theme, prayer.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(prayer.status),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Prayer Details
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                // Timestamp Info
                if (prayer.completedAt != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Completed at ${_formatTime(prayer.completedAt!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                ],
                
                if (prayer.missedAt != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: theme.colorScheme.error,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Missed at ${_formatTime(prayer.missedAt!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                ],
                
                // Action Buttons
                Row(
                  children: [
                    if (prayer.status == PrayerStatus.pending) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onStatusUpdated(
                            prayer.id,
                            PrayerStatus.completed,
                          ),
                          icon: Icon(Icons.check_rounded, size: 4.w),
                          label: Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onStatusUpdated(
                            prayer.id,
                            PrayerStatus.missed,
                          ),
                          icon: Icon(Icons.close_rounded, size: 4.w),
                          label: Text('Miss'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.colorScheme.error),
                          ),
                        ),
                      ),
                    ] else if (prayer.status == PrayerStatus.missed) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onMarkedAsQaza(prayer.id),
                          icon: Icon(Icons.replay_rounded, size: 4.w),
                          label: Text('Mark as Qaza'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onStatusUpdated(
                            prayer.id,
                            PrayerStatus.completed,
                          ),
                          icon: Icon(Icons.check_rounded, size: 4.w),
                          label: Text('Complete Now'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                            side: BorderSide(
                              color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                            ),
                          ),
                        ),
                      ),
                    ] else if (prayer.status == PrayerStatus.completed) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showNotesDialog(context),
                          icon: Icon(Icons.note_add_rounded, size: 4.w),
                          label: Text('Add Notes'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, PrayerStatus status) {
    switch (status) {
      case PrayerStatus.completed:
        return AppTheme.getSuccessColor(theme.brightness == Brightness.light);
      case PrayerStatus.missed:
        return theme.colorScheme.error;
      case PrayerStatus.qaza:
        return theme.colorScheme.secondary;
      case PrayerStatus.pending:
      default:
        return theme.colorScheme.outline;
    }
  }

  IconData _getPrayerIcon(PrayerType type) {
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

  String _getStatusText(PrayerStatus status) {
    switch (status) {
      case PrayerStatus.completed:
        return 'Completed';
      case PrayerStatus.missed:
        return 'Missed';
      case PrayerStatus.qaza:
        return 'Qaza';
      case PrayerStatus.pending:
      default:
        return 'Pending';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showNotesDialog(BuildContext context) {
    final notesController = TextEditingController(text: prayer.notes ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Notes'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onStatusUpdated(
                prayer.id,
                prayer.status,
                notes: notesController.text.isEmpty ? null : notesController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 