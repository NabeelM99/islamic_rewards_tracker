import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dua_action_buttons_widget.dart';
import './widgets/dua_content_widget.dart';
import '../../data/duas_repository.dart';

class DuaDetailScreen extends StatefulWidget {
  const DuaDetailScreen({Key? key}) : super(key: key);

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? selectedDua;
  List<Map<String, dynamic>> allDuas = [];
  int currentDuaIndex = 0;
  int currentCount = 0;
  int targetCount = 34; // Total number of duas in the category
  bool isCounting = false;
  
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isSlidingLeft = true; // Track slide direction

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _updateSlideAnimation();
  }

  void _updateSlideAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _isSlidingLeft ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get dua from navigation arguments or use first dua as default
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      // If navigator passed the dua directly
      selectedDua = args;
    } else if (args is Map && args.containsKey('dua')) {
      // If navigator wrapped it under 'dua' key
      final dynamic dua = args['dua'];
      if (dua is Map<String, dynamic>) {
        selectedDua = dua;
      }
    }

    // Fallback: first dua from first category
    selectedDua ??= (DuasRepository.instance.getCategories().first['duas'] as List).first as Map<String, dynamic>;

    // Load all duas from the same category
    _loadAllDuas();
  }

  void _loadAllDuas() {
    final categories = DuasRepository.instance.getCategories();
    String? categoryName;
    
    // Determine the category name from the selected dua
    if (selectedDua != null && selectedDua!.containsKey('category')) {
      categoryName = selectedDua!['category'] as String?;
    }
    
    // If no category found, default to Morning Adhkar for backward compatibility
    categoryName ??= 'Morning Adhkar';
    
    for (var category in categories) {
      if (category['name'] == categoryName) {
        allDuas = List<Map<String, dynamic>>.from(category['duas'] as List);
        break;
      }
    }

    // Find the current dua index
    if (selectedDua != null) {
      currentDuaIndex = allDuas.indexWhere((dua) => dua['id'] == selectedDua!['id']);
      if (currentDuaIndex == -1) {
        // If the current dua is not in the category, show only this dua
        currentDuaIndex = 0;
        allDuas = [selectedDua!];
      }
    }

    // Set current count based on index (1-based counting)
    currentCount = currentDuaIndex + 1;
    targetCount = allDuas.length;
  }

  void _onSwipeLeft() {
    if (currentDuaIndex < allDuas.length - 1) {
      HapticFeedback.lightImpact();
      
      // Set animation direction for sliding left (next dua) and trigger rebuild
      setState(() {
        _isSlidingLeft = true;
        _updateSlideAnimation();
      });
      
      // Start animation after rebuild
      Future.delayed(Duration.zero, () {
        _slideController.forward().then((_) {
          setState(() {
            currentDuaIndex++;
            selectedDua = allDuas[currentDuaIndex];
            currentCount = currentDuaIndex + 1;
            isCounting = true;
          });
          _slideController.reset();
          
          // Show completion celebration when reaching the last dua
          if (currentCount >= targetCount) {
            _showCompletionDialog();
          }
        });
      });
    } else {
      // Can't swipe further - show subtle feedback
      HapticFeedback.vibrate();
      String categoryName = selectedDua?['category'] as String? ?? 'Morning Adhkar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have completed all $categoryName!'),
          backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onSwipeRight() {
    if (currentDuaIndex > 0) {
      HapticFeedback.lightImpact();
      
      // Set animation direction for sliding right (previous dua) and trigger rebuild
      setState(() {
        _isSlidingLeft = false;
        _updateSlideAnimation();
      });
      
      // Start animation after rebuild
      Future.delayed(Duration.zero, () {
        _slideController.forward().then((_) {
          setState(() {
            currentDuaIndex--;
            selectedDua = allDuas[currentDuaIndex];
            currentCount = currentDuaIndex + 1;
            isCounting = true;
          });
          _slideController.reset();
        });
      });
    } else {
      // Can't swipe further - show subtle feedback
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('This is the first dua'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (selectedDua == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dua Detail'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,

        title: Text(
          selectedDua!['title'] as String? ?? 'Dua Detail',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${selectedDua!['times'] ?? 1}x',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar at the top (similar to tasbih counter)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$currentCount',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '$targetCount',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  LinearProgressIndicator(
                    value: targetCount > 0 ? currentCount / targetCount : 0.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      currentCount >= targetCount 
                          ? AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light)
                          : AppTheme.lightTheme.colorScheme.primary
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  if (currentCount >= targetCount)
                    Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Text(
                        '✓ Completed!',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
                        ),
                      ),
                    ),
                  SizedBox(height: 1.h),
                  // Swipe instruction
                  if (!isCounting)
                    Text(
                      allDuas.length > 1 
                          ? 'Swipe left to next dua • Swipe right to previous'
                          : 'Swipe functionality available for categories with multiple duas',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            // Swipeable Dua Content
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        // Swipe right - go to previous dua
                        _onSwipeRight();
                      } else if (details.primaryVelocity! < 0) {
                        // Swipe left - go to next dua
                        _onSwipeLeft();
                      }
                    },
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dua Content
                            DuaContentWidget(dua: selectedDua!),

                            SizedBox(height: 3.h),

                            // Additional Information Card
                            if (selectedDua!['reference'] != null ||
                                selectedDua!['benefits'] != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.lightTheme.colorScheme.shadow
                                          .withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (selectedDua!['reference'] != null) ...[
                                      Text(
                                        'Reference',
                                        style: AppTheme.lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.lightTheme.colorScheme.primary,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        selectedDua!['reference'] as String,
                                        style: AppTheme.lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme.onSurface,
                                        ),
                                      ),
                                      if (selectedDua!['benefits'] != null)
                                        SizedBox(height: 2.h),
                                    ],
                                    if (selectedDua!['benefits'] != null) ...[
                                      Text(
                                        'Benefits',
                                        style: AppTheme.lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.lightTheme.colorScheme.secondary,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        selectedDua!['benefits'] as String,
                                        style: AppTheme.lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: DuaActionButtonsWidget(dua: selectedDua!),
        ),
      ),
    );
  }



  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.celebration,
              color: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
              size: 28,
            ),
            SizedBox(width: 2.w),
            const Text('Congratulations!'),
          ],
        ),
        content: Text(
          'You have completed all ${targetCount} ${selectedDua?['category'] as String? ?? 'Morning Adhkar'}! May Allah accept your supplications.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentDuaIndex = 0;
                selectedDua = allDuas[0];
                currentCount = 1;
                isCounting = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
            ),
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }
}
