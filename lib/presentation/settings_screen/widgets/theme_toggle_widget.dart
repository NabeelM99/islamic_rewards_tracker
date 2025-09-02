import 'package:flutter/material.dart';

class ThemeToggleWidget extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeToggleWidget({
    Key? key,
    required this.isDarkMode,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle(bool value) {
    if (value != widget.isDarkMode) {
      _animationController.forward().then((_) {
        widget.onChanged(value);
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animation.value * 0.1),
          child: Switch.adaptive(
            value: widget.isDarkMode,
            onChanged: _handleToggle,
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            inactiveTrackColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }
}
