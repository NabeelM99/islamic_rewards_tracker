import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class EnhancedTasbihCounterWidget extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isCounting;
  final int currentCount;
  final int targetCount;

  const EnhancedTasbihCounterWidget({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.isCounting,
    required this.currentCount,
    required this.targetCount,
  });

  @override
  State<EnhancedTasbihCounterWidget> createState() => _EnhancedTasbihCounterWidgetState();
}

class _EnhancedTasbihCounterWidgetState extends State<EnhancedTasbihCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  // Cache the painter to avoid recreation
  static final TasbihPainter _tasbihPainter = TasbihPainter();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: AppTheme.smoothCurve),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) => _scaleController.reverse());
    widget.onTap();
  }

  void _onLongPress() {
    HapticFeedback.mediumImpact();
    _scaleController.forward().then((_) => _scaleController.reverse());
    widget.onLongPress();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tasbih Graphic
          GestureDetector(
            onTap: _onTap,
            onLongPress: _onLongPress,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 95.w,
                    height: 95.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Inner circle with subtle border
                        Center(
                          child: Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        
                        // Tasbih beads design - using cached painter
                        Center(
                          child: CustomPaint(
                            size: Size(80.w, 80.w),
                            painter: _tasbihPainter,
                          ),
                        ),
                        
                        // Tap text
                        Center(
                          child: Text(
                            'Tap',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 0.5.h),
          
          // Instructions
          Text(
            'Tap to count • Long press to reset',
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TasbihPainter extends CustomPainter {
  // Cache paint objects to avoid recreation
  static final Paint _outerPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
    
  static final Paint _innerPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
    
  static final Paint _beadPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Update colors for current theme
    _outerPaint.color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2);
    _innerPaint.color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.15);
    _beadPaint.color = AppTheme.lightTheme.colorScheme.primary;

    // Draw outer decorative circle
    canvas.drawCircle(center, radius + 8, _outerPaint);

    // Draw inner decorative circle
    canvas.drawCircle(center, radius - 8, _innerPaint);

    // Draw beads in a circle with improved spacing
    final beadRadius = 4.0;
    final beadCount = 33;
    final beadCircleRadius = radius * 0.65;

    for (int i = 0; i < beadCount; i++) {
      final angle = (i * 2 * pi) / beadCount;
      final x = center.dx + beadCircleRadius * cos(angle);
      final y = center.dy + beadCircleRadius * sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        beadRadius,
        _beadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 