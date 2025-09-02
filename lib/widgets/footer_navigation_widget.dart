import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../routes/app_routes.dart';
import '../core/utils/smooth_navigation.dart';

class FooterNavigationWidget extends StatelessWidget {
  final String currentRoute;

  const FooterNavigationWidget({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.bottomNavigationBarTheme.backgroundColor,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Container(
          height: 9.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_rounded,
                route: AppRoutes.home,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.home),
              ),
              _NavBarItem(
                icon: Icons.menu_book_rounded,
                route: AppRoutes.duas,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.duas),
              ),
              _NavBarItem(
                icon: Icons.person_rounded,
                route: AppRoutes.profile,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.profile),
              ),
              _NavBarItem(
                icon: Icons.history_rounded,
                route: AppRoutes.history,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.history),
              ),
              _NavBarItem(
                icon: Icons.settings_rounded,
                route: AppRoutes.settings,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    if (route != currentRoute) {
      context.smoothPushReplacementNamed(route);
    }
  }
}

class _NavBarItem extends StatefulWidget {
  final IconData icon;
  final String route;
  final String currentRoute;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.route,
    required this.currentRoute,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  // Cache for performance
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppTheme.smoothCurve,
    ));
    _colorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
      end: AppTheme.lightTheme.colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppTheme.smoothCurve,
    ));
    
    // Initialize selection state
    _updateSelectionState();
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if selection state changed
    if (oldWidget.currentRoute != widget.currentRoute) {
      _updateSelectionState();
    }
  }

  void _updateSelectionState() {
    final newIsSelected = widget.route == widget.currentRoute;
    if (newIsSelected != _isSelected) {
      _isSelected = newIsSelected;
      if (_isSelected && _animationController.value == 0) {
        _animationController.forward();
      } else if (!_isSelected && _animationController.value == 1) {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isSelected 
                    ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
              ),
              child: Icon(
                widget.icon,
                size: 7.w,
                color: _colorAnimation.value,
              ),
            ),
          );
        },
      ),
    );
  }
}
