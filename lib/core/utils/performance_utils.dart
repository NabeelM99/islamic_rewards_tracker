import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class for performance optimizations
class PerformanceUtils {
  PerformanceUtils._();

  /// Enable performance optimizations for the app
  static void enablePerformanceOptimizations() {
    // Enable hardware acceleration
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  /// Optimize image loading for better performance
  static Widget optimizeImage({
    required String imagePath,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: (width * 2).toInt(), // Optimize for high DPI screens
      cacheHeight: (height * 2).toInt(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Icon(Icons.error);
      },
    );
  }

  /// Create a debounced function to prevent excessive calls
  static Function debounce(Function func, Duration wait) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(wait, () => func());
    };
  }

  /// Optimize list performance with proper keys
  static Widget optimizedListView({
    required List<Widget> children,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return KeyedSubtree(
          key: ValueKey('list_item_$index'),
          child: children[index],
        );
      },
    );
  }

  /// Create a performance-optimized grid
  static Widget optimizedGridView({
    required List<Widget> children,
    required int crossAxisCount,
    double crossAxisSpacing = 0,
    double mainAxisSpacing = 0,
    double childAspectRatio = 1.0,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return KeyedSubtree(
          key: ValueKey('grid_item_$index'),
          child: children[index],
        );
      },
    );
  }

  /// Optimize text rendering
  static Widget optimizedText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool softWrap = true,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      // Enable text optimization
      textScaleFactor: 1.0,
    );
  }

  /// Create a performance-optimized button
  static Widget optimizedButton({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool isEnabled = true,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: style,
      child: child,
    );
  }

  /// Optimize animations with proper disposal
  static void disposeAnimationController(AnimationController? controller) {
    controller?.dispose();
  }

  /// Create a memory-efficient cached widget
  static Widget cachedWidget({
    required Widget child,
    String? key,
  }) {
    return RepaintBoundary(
      child: KeyedSubtree(
        key: key != null ? ValueKey(key) : null,
        child: child,
      ),
    );
  }

  /// Optimize scroll performance
  static ScrollPhysics getOptimizedScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  /// Create a performance-optimized container
  static Widget optimizedContainer({
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      child: child,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// Optimize icon rendering
  static Widget optimizedIcon(
    IconData icon, {
    double? size,
    Color? color,
  }) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }

  /// Create a performance-optimized spacer
  static Widget optimizedSpacer({int flex = 1}) {
    return Spacer(flex: flex);
  }

  /// Optimize sized box
  static Widget optimizedSizedBox({
    double? width,
    double? height,
    Widget? child,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  /// Create a performance-optimized list item with proper keys
  static Widget optimizedListItem({
    required Widget child,
    required int index,
    String? prefix,
  }) {
    return KeyedSubtree(
      key: ValueKey('${prefix ?? 'item'}_$index'),
      child: RepaintBoundary(child: child),
    );
  }

  /// Optimize expensive calculations with memoization
  static T memoize<T>(T Function() computation, {String? key}) {
    final Map<String, T> _cache = {};
    
    if (key != null && _cache.containsKey(key)) {
      return _cache[key]!;
    }
    
    final result = computation();
    if (key != null) {
      _cache[key] = result;
    }
    return result;
  }

  /// Clear memoization cache
  static void clearMemoizationCache() {
    final Map<String, dynamic> _cache = {};
    _cache.clear();
  }

  /// Optimize widget rebuilds with RepaintBoundary
  static Widget withRepaintBoundary(Widget child) {
    return RepaintBoundary(child: child);
  }

  /// Create a performance-optimized column
  static Widget optimizedColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /// Create a performance-optimized row
  static Widget optimizedRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /// Optimize padding widget
  static Widget optimizedPadding({
    required Widget child,
    required EdgeInsetsGeometry padding,
  }) {
    return Padding(
      padding: padding,
      child: child,
    );
  }

  /// Create a performance-optimized center widget
  static Widget optimizedCenter({
    required Widget child,
    double? widthFactor,
    double? heightFactor,
  }) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }

  /// Optimize expanded widget
  static Widget optimizedExpanded({
    required Widget child,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }

  /// Create a performance-optimized flexible widget
  static Widget optimizedFlexible({
    required Widget child,
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
} 