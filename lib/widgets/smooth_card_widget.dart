import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_theme.dart';

/// A smooth card widget with consistent animations and interactions
class SmoothCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothCard({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothCard> createState() => _SmoothCardState();
}

class _SmoothCardState extends State<SmoothCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AppTheme.fastAnimation,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? AppTheme.smoothCurve,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? AppTheme.smoothCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap?.call();
    });
  }

  void _handleLongPress() {
    if (!widget.isEnabled) return;
    
    HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Material(
              elevation: (widget.elevation ?? 2) * _elevationAnimation.value,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              color: widget.color ?? AppTheme.lightTheme.colorScheme.surface,
              shadowColor: AppTheme.shadowLight,
              child: InkWell(
                onTap: widget.isEnabled ? _handleTap : null,
                onLongPress: widget.isEnabled ? _handleLongPress : null,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                splashColor: widget.showRipple 
                    ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                highlightColor: widget.showRipple
                    ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
                    : Colors.transparent,
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(4.w),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A smooth list tile with consistent animations
class SmoothListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothListTile> createState() => _SmoothListTileState();
}

class _SmoothListTileState extends State<SmoothListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AppTheme.fastAnimation,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? AppTheme.smoothCurve,
    ));
    
    _colorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.surface,
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? AppTheme.smoothCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap?.call();
    });
  }

  void _handleLongPress() {
    if (!widget.isEnabled) return;
    
    HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isEnabled ? _handleTap : null,
                onLongPress: widget.isEnabled ? _handleLongPress : null,
                borderRadius: BorderRadius.circular(8),
                splashColor: widget.showRipple 
                    ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                highlightColor: widget.showRipple
                    ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
                    : Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        SizedBox(width: 3.w),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null) widget.title!,
                            if (widget.subtitle != null) ...[
                              SizedBox(height: 0.5.h),
                              widget.subtitle!,
                            ],
                          ],
                        ),
                      ),
                      if (widget.trailing != null) ...[
                        SizedBox(width: 2.w),
                        widget.trailing!,
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