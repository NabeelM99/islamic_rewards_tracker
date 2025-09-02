import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/dhikr_model.dart';
import '../../../theme/app_theme.dart';

import '../../../core/app_export.dart';

class TasbihCounterWidget extends StatefulWidget {
  final DhikrModel dhikr;
  final Function(int) onCountUpdate;

  const TasbihCounterWidget({
    super.key,
    required this.dhikr,
    required this.onCountUpdate,
  });

  @override
  State<TasbihCounterWidget> createState() => _TasbihCounterWidgetState();
}

class _TasbihCounterWidgetState extends State<TasbihCounterWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap() async {
    // Vibration feedback
    HapticFeedback.lightImpact();
    
    // Scale animation
    _scaleController.forward().then((_) => _scaleController.reverse());
    
    // Pulse animation
    _pulseController.forward().then((_) => _pulseController.reverse());
    
    // Update count
    final newCount = widget.dhikr.currentCount + 1;
    widget.onCountUpdate(newCount);
  }

  void _onLongPress() async {
    // Stronger vibration for long press
    HapticFeedback.heavyImpact();
    
    // Reset count
    widget.onCountUpdate(0);
  }

  void _onDoubleTap() async {
    // Medium vibration for double tap
    HapticFeedback.mediumImpact();
    
    // Decrease count
    final newCount = (widget.dhikr.currentCount - 1).clamp(0, double.infinity).toInt();
    widget.onCountUpdate(newCount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.dhikr.targetCount > 0 
        ? widget.dhikr.currentCount / widget.dhikr.targetCount 
        : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dhikr Title
          Text(
            widget.dhikr.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 2.h),
          
          // Arabic Text (if available)
          if (widget.dhikr.arabicText != null) ...[
            Text(
              widget.dhikr.arabicText!,
              style: IndoPakFonts.getUthmaniTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 2.h),
          ],
          
          // Progress Bar
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppTheme.getSuccessColor(theme.brightness == Brightness.light) : theme.colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          SizedBox(height: 3.h),
          
          // Count Display
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Text(
                  '${widget.dhikr.currentCount}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progress >= 1.0 ? AppTheme.getSuccessColor(theme.brightness == Brightness.light) : theme.colorScheme.primary,
                  ),
                ),
              );
            },
          ),
          
          Text(
            'of ${widget.dhikr.targetCount}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Counter Button
          GestureDetector(
            onTap: _onTap,
            onLongPress: _onLongPress,
            onDoubleTap: _onDoubleTap,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.touch_app_rounded,
                      size: 12.w,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Instructions
          Text(
            'Tap to count • Double tap to decrease • Long press to reset',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 