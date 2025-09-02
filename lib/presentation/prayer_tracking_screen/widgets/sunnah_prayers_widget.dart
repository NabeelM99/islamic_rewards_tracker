import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/prayer_model.dart';
import '../../../theme/app_theme.dart';

class SunnahPrayersWidget extends StatelessWidget {
  final List<SunnahPrayerModel> sunnahPrayers;
  final Function(String, int, {String? notes}) onSunnahUpdated;

  const SunnahPrayersWidget({
    super.key,
    required this.sunnahPrayers,
    required this.onSunnahUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (sunnahPrayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              size: 15.w,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Sunnah Prayers',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Add some optional prayers to track',
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
      itemCount: sunnahPrayers.length,
      itemBuilder: (context, index) {
        final sunnah = sunnahPrayers[index];
        return _SunnahPrayerCard(
          sunnah: sunnah,
          onSunnahUpdated: onSunnahUpdated,
        );
      },
    );
  }
}

class _SunnahPrayerCard extends StatelessWidget {
  final SunnahPrayerModel sunnah;
  final Function(String, int, {String? notes}) onSunnahUpdated;

  const _SunnahPrayerCard({
    required this.sunnah,
    required this.onSunnahUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = sunnah.targetRakats != null && sunnah.targetRakats! > 0
        ? sunnah.completedRakats / sunnah.targetRakats!
        : 0.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getAccentColor(theme.brightness == Brightness.light).withValues(alpha: 0.3),
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
          // Sunnah Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.getAccentColor(theme.brightness == Brightness.light).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                // Sunnah Icon
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSunnahIcon(sunnah.type),
                    color: theme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
                
                SizedBox(width: 4.w),
                
                // Sunnah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sunnah.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                        ),
                      ),
                      if (sunnah.arabicText != null && sunnah.arabicText!.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          sunnah.arabicText!,
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
                
                // Completion Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: sunnah.isCompleted 
                        ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
                        : AppTheme.getAccentColor(theme.brightness == Brightness.light),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sunnah.isCompleted ? 'Completed' : 'Optional',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Sunnah Details
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                // Translation
                if (sunnah.translation != null && sunnah.translation!.isNotEmpty) ...[
                  Text(
                    sunnah.translation!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                ],
                
                // Progress Section
                if (sunnah.targetRakats != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${sunnah.completedRakats}/${sunnah.targetRakats} rakats',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 1.h),
                  
                  // Progress Bar
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      sunnah.isCompleted 
                          ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
                          : AppTheme.getAccentColor(theme.brightness == Brightness.light),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  SizedBox(height: 2.h),
                ],
                
                // Completion Time
                if (sunnah.completedAt != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Completed at ${_formatTime(sunnah.completedAt!)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
                
                // Notes
                if (sunnah.notes != null && sunnah.notes!.isNotEmpty) ...[
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
                            sunnah.notes!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
                
                // Action Buttons
                if (!sunnah.isCompleted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showUpdateDialog(context),
                          icon: Icon(Icons.edit_rounded, size: 4.w),
                          label: Text('Update Progress'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                            side: BorderSide(
                              color: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _completeSunnah(context),
                          icon: Icon(Icons.check_rounded, size: 4.w),
                          label: Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.getSuccessColor(theme.brightness == Brightness.light),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showUpdateDialog(context),
                      icon: Icon(Icons.edit_rounded, size: 4.w),
                      label: Text('Update Notes'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                        side: BorderSide(
                          color: AppTheme.getAccentColor(theme.brightness == Brightness.light),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSunnahIcon(SunnahType type) {
    switch (type) {
      case SunnahType.tahajjud:
        return Icons.nights_stay_rounded;
      case SunnahType.duha:
        return Icons.wb_sunny_rounded;
      case SunnahType.witr:
        return Icons.star_rounded;
      case SunnahType.nafl:
        return Icons.favorite_rounded;
      case SunnahType.other:
        return Icons.star_outline_rounded;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showUpdateDialog(BuildContext context) {
    final rakatsController = TextEditingController(text: sunnah.completedRakats.toString());
    final notesController = TextEditingController(text: sunnah.notes ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${sunnah.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sunnah.targetRakats != null) ...[
              TextField(
                controller: rakatsController,
                decoration: const InputDecoration(
                  labelText: 'Completed Rakats',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 2.h),
            ],
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final rakats = int.tryParse(rakatsController.text) ?? sunnah.completedRakats;
              onSunnahUpdated(
                sunnah.id,
                rakats,
                notes: notesController.text.isEmpty ? null : notesController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _completeSunnah(BuildContext context) {
    if (sunnah.targetRakats != null) {
      onSunnahUpdated(
        sunnah.id,
        sunnah.targetRakats!,
        notes: sunnah.notes,
      );
    }
  }
} 