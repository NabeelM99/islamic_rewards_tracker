import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(String taskId, bool isCompleted) onTaskToggle;
  final Function(String taskId, int count) onCounterUpdate;
  final VoidCallback onTaskDetails;

  const TaskCardWidget({
    Key? key,
    required this.task,
    required this.onTaskToggle,
    required this.onCounterUpdate,
    required this.onTaskDetails,
  }) : super(key: key);

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.surface,
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _handleTaskToggle() {
    _handleTap();
    final bool currentStatus = widget.task['isCompleted'] ?? false;
    widget.onTaskToggle(widget.task['id'], !currentStatus);
  }

  void _incrementCounter() {
    _handleTap();
    final int currentCount = widget.task['currentCount'] ?? 0;
    final int targetCount = widget.task['targetCount'] ?? 1;
    if (currentCount < targetCount) {
      widget.onCounterUpdate(widget.task['id'], currentCount + 1);
    }
  }

  void _decrementCounter() {
    _handleTap();
    final int currentCount = widget.task['currentCount'] ?? 0;
    if (currentCount > 0) {
      widget.onCounterUpdate(widget.task['id'], currentCount - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.task['isCompleted'] ?? false;
    final bool isCarryOver = widget.task['isCarryOver'] ?? false;
    final String taskType = widget.task['type'] ?? 'checkbox';
    final int currentCount = widget.task['currentCount'] ?? 0;
    final int targetCount = widget.task['targetCount'] ?? 1;
    final double progress = targetCount > 0 ? currentCount / targetCount : 0.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Card(
              elevation: isCompleted ? 1 : 3,
              color: _colorAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isCarryOver
                    ? BorderSide(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        width: 2,
                      )
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: widget.onTaskDetails,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Arabic Name
                                Text(
                                  widget.task['arabicName'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 0.5.h),
                                // English Translation
                                Text(
                                  widget.task['englishName'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.5)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          // Carry Over Badge
                          if (isCarryOver)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Carry Over',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Task Interface
                      if (taskType == 'checkbox') ...[
                        // Checkbox Interface
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _handleTaskToggle,
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: isCompleted
                                    ? CustomIconWidget(
                                        iconName: 'check',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 4.w,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                isCompleted ? 'Completed' : 'Mark as Complete',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: isCompleted
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: isCompleted
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Counter Interface
                        Column(
                          children: [
                            // Progress Bar
                            Container(
                              width: double.infinity,
                              height: 1.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: progress >= 1.0
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.5.h),
                            // Counter Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Decrement Button
                                GestureDetector(
                                  onTap: currentCount > 0
                                      ? _decrementCounter
                                      : null,
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: currentCount > 0
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : AppTheme
                                              .lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: currentCount > 0
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'remove',
                                      color: currentCount > 0
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                                // Counter Display
                                Column(
                                  children: [
                                    Text(
                                      '$currentCount / $targetCount',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: progress >= 1.0
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toInt()}% Complete',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                // Increment Button
                                GestureDetector(
                                  onTap: currentCount < targetCount
                                      ? _incrementCounter
                                      : null,
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: currentCount < targetCount
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : AppTheme
                                              .lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: currentCount < targetCount
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'add',
                                      color: currentCount < targetCount
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
