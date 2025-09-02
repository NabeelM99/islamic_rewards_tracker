import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

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
  
  // Cache for expensive calculations
  late bool _isCompleted;
  late bool _isCarryOver;
  late String _taskType;
  late int _currentCount;
  late int _targetCount;
  late double _progress;

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
    
    // Initialize cached values
    _updateCachedValues();
  }

  @override
  void didUpdateWidget(TaskCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update cached values if task data changed
    if (oldWidget.task != widget.task) {
      _updateCachedValues();
    } else {
      // Even if the task object is the same, the internal values might have changed
      // Check if any key values have changed
      final oldCompleted = oldWidget.task['isCompleted'] ?? false;
      final newCompleted = widget.task['isCompleted'] ?? false;
      final oldCount = oldWidget.task['currentCount'] ?? 0;
      final newCount = widget.task['currentCount'] ?? 0;
      
      if (oldCompleted != newCompleted || oldCount != newCount) {
        _updateCachedValues();
      }
    }
  }

  void _updateCachedValues() {
    _isCompleted = widget.task['isCompleted'] ?? false;
    _isCarryOver = widget.task['isCarryOver'] ?? false;
    _taskType = widget.task['type'] ?? 'checkbox';
    _currentCount = widget.task['currentCount'] ?? 0;
    _targetCount = widget.task['targetCount'] ?? 1;
    _progress = _targetCount > 0 ? _currentCount / _targetCount : 0.0;
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
    // Update cached values immediately for instant UI feedback
    setState(() {
      _isCompleted = !_isCompleted;
    });
    widget.onTaskToggle(widget.task['id'], _isCompleted);
  }

  void _incrementCounter() {
    _handleTap();
    if (_currentCount < _targetCount) {
      final newCount = _currentCount + 1;
      // Update cached values immediately for instant UI feedback
      setState(() {
        _currentCount = newCount;
        _progress = _targetCount > 0 ? _currentCount / _targetCount : 0.0;
        _isCompleted = _currentCount >= _targetCount;
      });
      widget.onCounterUpdate(widget.task['id'], _currentCount);
    }
  }

  void _decrementCounter() {
    _handleTap();
    if (_currentCount > 0) {
      final newCount = _currentCount - 1;
      // Update cached values immediately for instant UI feedback
      setState(() {
        _currentCount = newCount;
        _progress = _targetCount > 0 ? _currentCount / _targetCount : 0.0;
        _isCompleted = _currentCount >= _targetCount;
      });
      widget.onCounterUpdate(widget.task['id'], _currentCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Card(
              elevation: _isCompleted ? 1 : 3,
              color: _colorAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: _isCarryOver
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
                                if (widget.task['arabicName'] != null &&
                                    (widget.task['arabicName'] as String).isNotEmpty) ...[
                                                                  Text(
                                  widget.task['arabicName'] ?? '',
                                  style: IndoPakFonts.getUthmaniTextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                  SizedBox(height: 0.5.h),
                                ],
                                // English Translation
                                Text(
                                  widget.task['englishName'] ?? '',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: _isCompleted
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
                          if (_isCarryOver)
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
                      if (_taskType == 'checkbox') ...[
                        // Checkbox Interface
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _handleTaskToggle,
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: _isCompleted
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: _isCompleted
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
                                _isCompleted ? 'Completed' : 'Mark as Complete',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: _isCompleted
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                  fontWeight: _isCompleted
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
                                widthFactor: _progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _progress >= 1.0
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
                                  onTap: _currentCount > 0
                                      ? _decrementCounter
                                      : null,
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: _currentCount > 0
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : AppTheme
                                              .lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _currentCount > 0
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'remove',
                                      color: _currentCount > 0
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
                                      '$_currentCount / $_targetCount',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: _progress >= 1.0
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                    Text(
                                      '${(_progress * 100).toInt()}% Complete',
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
                                  onTap: _currentCount < _targetCount
                                      ? _incrementCounter
                                      : null,
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: _currentCount < _targetCount
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : AppTheme
                                              .lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _currentCount < _targetCount
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'add',
                                      color: _currentCount < _targetCount
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
