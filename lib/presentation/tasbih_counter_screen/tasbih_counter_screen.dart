import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/dhikr_model.dart';
import '../../core/services/dhikr_storage.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'widgets/enhanced_tasbih_counter_widget.dart';
import 'widgets/enhanced_dhikr_selector_widget.dart';

class TasbihCounterScreen extends StatefulWidget {
  const TasbihCounterScreen({super.key});

  @override
  State<TasbihCounterScreen> createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  final DhikrStorageService _dhikrService = DhikrStorageService();
  DhikrModel? _selectedDhikr;
  List<DhikrModel> _dhikrList = [];
  bool _isLoading = true;
  int _currentCount = 0;
  int _targetCount = 33;
  bool _isCounting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final dhikrList = await _dhikrService.getAllDhikr();
      
      setState(() {
        _dhikrList = dhikrList;
        _selectedDhikr = dhikrList.isNotEmpty ? dhikrList.first : null;
        if (_selectedDhikr != null) {
          _currentCount = _selectedDhikr!.currentCount;
          _targetCount = _selectedDhikr!.targetCount;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTasbihTap() {
    if (!_isCounting) {
      setState(() {
        _isCounting = true;
      });
    }
    
    HapticFeedback.lightImpact();
    
    setState(() {
      _currentCount++;
    });
    
    if (_selectedDhikr != null) {
      _dhikrService.updateDhikrCount(_selectedDhikr!.id, _currentCount);
    }
  }

  void _onTasbihLongPress() {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _currentCount = 0;
      _isCounting = false;
    });
    
    if (_selectedDhikr != null) {
      _dhikrService.updateDhikrCount(_selectedDhikr!.id, 0);
    }
  }

  void _onTargetChange() {
    HapticFeedback.lightImpact();
    
    final controller = TextEditingController(text: _targetCount.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Target'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Count',
                border: OutlineInputBorder(),
              ),
              controller: controller,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newTarget = int.tryParse(controller.text);
              if (newTarget != null && newTarget > 0) {
                setState(() {
                  _targetCount = newTarget;
                });
                
                // Save the target to storage
                if (_selectedDhikr != null) {
                  await _dhikrService.updateDhikrTarget(_selectedDhikr!.id, newTarget);
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _onDhikrSelected(DhikrModel dhikr) {
    setState(() {
      _selectedDhikr = dhikr;
      _currentCount = dhikr.currentCount;
      _targetCount = dhikr.targetCount;
      _isCounting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Loading your tasbih...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FooterNavigationWidget(
          currentRoute: AppRoutes.tasbihCounter,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        title: Text(
          'Tasbih Counter',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar and Count
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_currentCount',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '$_targetCount',
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
                    value: _targetCount > 0 ? _currentCount / _targetCount : 0.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.colorScheme.primary),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),

            // Dhikr Selector
            EnhancedDhikrSelectorWidget(
              dhikrList: _dhikrList,
              selectedDhikr: _selectedDhikr,
              onDhikrSelected: _onDhikrSelected,
            ),

            // Main Tasbih Area
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 0.5.h),
                child: EnhancedTasbihCounterWidget(
                  onTap: _onTasbihTap,
                  onLongPress: _onTasbihLongPress,
                  isCounting: _isCounting,
                  currentCount: _currentCount,
                  targetCount: _targetCount,
                ),
              ),
            ),

            // Target Button Only
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TARGET Button
                  GestureDetector(
                    onTap: _onTargetChange,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.gps_fixed,
                        size: 6.w,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigationWidget(
        currentRoute: AppRoutes.tasbihCounter,
      ),
    );
  }
} 