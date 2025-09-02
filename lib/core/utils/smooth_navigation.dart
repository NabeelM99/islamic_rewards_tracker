import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

/// Utility class for smooth navigation throughout the app
class SmoothNavigation {
  /// Navigate to a new screen with smooth slide transition
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool slideFromRight = true,
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          return AppRoutes.routes[routeName]!(context);
        },
        transitionDuration: AppTheme.normalAnimation,
        reverseTransitionDuration: AppTheme.normalAnimation,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: AppTheme.smoothCurve,
            reverseCurve: AppTheme.smoothCurve,
          );
          
          final begin = slideFromRight 
              ? const Offset(1.0, 0.0) 
              : const Offset(-1.0, 0.0);
          const end = Offset.zero;
          
          final slideAnimation = Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(curved);
          
          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
        },
      ),
    );
  }

  /// Navigate to a new screen and replace the current one
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacement<T, TO>(
      context,
      PageRouteBuilder<T>(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          return AppRoutes.routes[routeName]!(context);
        },
        transitionDuration: AppTheme.normalAnimation,
        reverseTransitionDuration: AppTheme.normalAnimation,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: AppTheme.smoothCurve,
            reverseCurve: AppTheme.smoothCurve,
          );
          
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.95,
                end: 1.0,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
      result: result,
    );
  }

  /// Navigate to a new screen and clear the navigation stack
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      PageRouteBuilder<T>(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          return AppRoutes.routes[routeName]!(context);
        },
        transitionDuration: AppTheme.normalAnimation,
        reverseTransitionDuration: AppTheme.normalAnimation,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: AppTheme.smoothCurve,
            reverseCurve: AppTheme.smoothCurve,
          );
          
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
      predicate,
    );
  }

  /// Show a smooth modal dialog
  static Future<T?> showDialog<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: AppTheme.normalAnimation,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppTheme.smoothCurve,
          reverseCurve: AppTheme.smoothCurve,
        );
        
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(curved),
            child: child,
          ),
        );
      },
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Show a smooth bottom sheet
  static Future<T?> showBottomSheet<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }
}

/// Extension to add smooth navigation methods to BuildContext
extension SmoothNavigationExtension on BuildContext {
  /// Navigate to a new screen with smooth transition
  Future<T?> smoothPushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool slideFromRight = true,
  }) {
    return SmoothNavigation.pushNamed<T>(
      this,
      routeName,
      arguments: arguments,
      slideFromRight: slideFromRight,
    );
  }

  /// Navigate to a new screen and replace the current one
  Future<T?> smoothPushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return SmoothNavigation.pushReplacementNamed<T, TO>(
      this,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate to a new screen and clear the navigation stack
  Future<T?> smoothPushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return SmoothNavigation.pushNamedAndRemoveUntil<T>(
      this,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Show a smooth modal dialog
  Future<T?> smoothShowDialog<T extends Object?>(
    WidgetBuilder builder, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return SmoothNavigation.showDialog<T>(
      this,
      builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Show a smooth bottom sheet
  Future<T?> smoothShowBottomSheet<T extends Object?>(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    return SmoothNavigation.showBottomSheet<T>(
      this,
      builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }
} 