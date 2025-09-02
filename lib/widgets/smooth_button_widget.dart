import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_theme.dart';

/// A smooth button widget with consistent animations and optimized performance
class SmoothButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.style,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothButton> createState() => _SmoothButtonState();
}

class _SmoothButtonState extends State<SmoothButton>
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
      end: 0.95,
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
      widget.onPressed?.call();
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
          child: Material(
            elevation: _elevationAnimation.value * 2,
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isEnabled ? _handleTap : null,
              onLongPress: widget.isEnabled ? _handleLongPress : null,
              borderRadius: BorderRadius.circular(12),
              splashColor: widget.showRipple 
                  ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              highlightColor: widget.showRipple
                  ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.isEnabled
                      ? (widget.style?.backgroundColor?.resolve({}) ?? 
                         AppTheme.lightTheme.colorScheme.primary)
                      : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.12),
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A smooth elevated button with consistent styling and optimized performance
class SmoothElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothElevatedButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.style,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothElevatedButton> createState() => _SmoothElevatedButtonState();
}

class _SmoothElevatedButtonState extends State<SmoothElevatedButton>
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
      end: 0.95,
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
      widget.onPressed?.call();
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
          child: ElevatedButton(
            onPressed: widget.isEnabled ? _handleTap : null,
            style: widget.style?.copyWith(
              elevation: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return 1.0;
                }
                return 2.0 * _elevationAnimation.value;
              }),
            ) ?? ElevatedButton.styleFrom(
              elevation: 2.0 * _elevationAnimation.value,
              shadowColor: AppTheme.shadowLight,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// A smooth outlined button with consistent styling and optimized performance
class SmoothOutlinedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothOutlinedButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.style,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothOutlinedButton> createState() => _SmoothOutlinedButtonState();
}

class _SmoothOutlinedButtonState extends State<SmoothOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AppTheme.fastAnimation,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
      widget.onPressed?.call();
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
          child: OutlinedButton(
            onPressed: widget.isEnabled ? _handleTap : null,
            style: widget.style,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// A smooth icon button with consistent animations and optimized performance
class SmoothIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final IconData icon;
  final Color? color;
  final double? size;
  final bool isEnabled;
  final bool showRipple;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const SmoothIconButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    required this.icon,
    this.color,
    this.size,
    this.isEnabled = true,
    this.showRipple = true,
    this.animationDuration,
    this.animationCurve,
  }) : super(key: key);

  @override
  State<SmoothIconButton> createState() => _SmoothIconButtonState();
}

class _SmoothIconButtonState extends State<SmoothIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AppTheme.fastAnimation,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? AppTheme.smoothCurve,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
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
      widget.onPressed?.call();
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
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: IconButton(
              onPressed: widget.isEnabled ? _handleTap : null,
              icon: Icon(
                widget.icon,
                color: widget.color ?? AppTheme.lightTheme.colorScheme.primary,
                size: widget.size ?? 24,
              ),
              splashColor: widget.showRipple 
                  ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              highlightColor: widget.showRipple
                  ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
            ),
          ),
        );
      },
    );
  }
} 