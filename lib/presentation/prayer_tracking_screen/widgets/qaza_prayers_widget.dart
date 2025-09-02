import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/prayer_model.dart';
import '../../../theme/app_theme.dart';

class QazaPrayersWidget extends StatelessWidget {
  final List<PrayerModel> qazaPrayers;
  final Function(String) onQazaCompleted;

  const QazaPrayersWidget({
    super.key,
    required this.qazaPrayers,
    required this.onQazaCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (qazaPrayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.replay_rounded,
              size: 15.w,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Qaza Prayers',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'All your prayers are up to date!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(3.w),
      itemCount: qazaPrayers.length,
      itemBuilder: (context, index) {
        final prayer = qazaPrayers[index];
        return _QazaPrayerCard(
          prayer: prayer,
          onQazaCompleted: onQazaCompleted,
        );
      },
    );
  }
}

class _QazaPrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final Function(String) onQazaCompleted;

  const _QazaPrayerCard({
    required this.prayer,
    required this.onQazaCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 2,
        ),
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
          // Qaza Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                // Qaza Icon
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.replay_rounded,
                    color: theme.colorScheme.onSecondary,
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
                        'Qaza ${prayer.displayName}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      if (prayer.arabicName.isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Text(
                          prayer.arabicName,
                          style: AppTheme.arabicTextTheme(
                            isLight: theme.brightness == Brightness.light
                          ).titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Qaza Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Qaza',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Qaza Details
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                // Missed Date Info
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.error,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Missed on ${_formatDate(prayer.date)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                
                if (prayer.missedAt != null) ...[
                  SizedBox(height: 1.h),
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
                ],
                
                if (prayer.notes != null && prayer.notes!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_rounded,
                          color: theme.colorScheme.outline,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            prayer.notes!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: 3.h),
                
                // Complete Qaza Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onQazaCompleted(prayer.id),
                    icon: Icon(Icons.check_circle_rounded, size: 5.w),
                    label: Text(
                      'Complete Qaza Prayer',
                      style: theme.textTheme.labelLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
} 