import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../routes/app_routes.dart';

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
                label: 'Home',
                route: AppRoutes.home,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.home),
              ),
              _NavBarItem(
                icon: Icons.menu_book_rounded,
                label: 'Duas',
                route: AppRoutes.duas,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.duas),
              ),
              _NavBarItem(
                icon: Icons.radio_button_checked,
                label: 'Tasbih',
                route: AppRoutes.tasbihCounter,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.tasbihCounter),
              ),
              _NavBarItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                route: AppRoutes.profile,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.profile),
              ),
              _NavBarItem(
                icon: Icons.history_rounded,
                label: 'History',
                route: AppRoutes.history,
                currentRoute: currentRoute,
                onTap: () => _navigateToRoute(context, AppRoutes.history),
              ),
              _NavBarItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: RouteSettings(name: route),
          pageBuilder: (context, animation, secondaryAnimation) =>
              AppRoutes.routes[route]!(context),
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 180),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(opacity: curved, child: child);
          },
        ),
      );
    }
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;
  final VoidCallback onTap;

  const _NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = route == currentRoute;
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.all(isSelected ? 1.w : 0.5.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: isSelected ? 6.w : 5.5.w,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
              SizedBox(height: 0.5.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: (isSelected
                        ? theme.bottomNavigationBarTheme.selectedLabelStyle
                        : theme
                            .bottomNavigationBarTheme.unselectedLabelStyle) ??
                    TextStyle(
                      fontSize: isSelected ? 9.sp : 8.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
