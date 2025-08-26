import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/dhikr_model.dart';
import '../../core/services/dhikr_storage.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'widgets/tasbih_counter_widget.dart';
import 'widgets/dhikr_selector_widget.dart';
import 'widgets/daily_targets_widget.dart';

class TasbihCounterScreen extends StatefulWidget {
  const TasbihCounterScreen({super.key});

  @override
  State<TasbihCounterScreen> createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  final DhikrStorageService _dhikrService = DhikrStorageService();
  DhikrModel? _selectedDhikr;
  List<DhikrModel> _dhikrList = [];
  Map<String, int> _dailyTargets = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final dhikrList = await _dhikrService.getAllDhikr();
      final dailyTargets = await _dhikrService.getDailyTargets();
      
      setState(() {
        _dhikrList = dhikrList;
        _dailyTargets = dailyTargets;
        _selectedDhikr = dhikrList.isNotEmpty ? dhikrList.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onCountUpdate(int newCount) async {
    if (_selectedDhikr != null) {
      await _dhikrService.updateDhikrCount(_selectedDhikr!.id, newCount);
      
      // Update local state
      setState(() {
        _selectedDhikr = _selectedDhikr!.copyWith(currentCount: newCount);
      });
    }
  }

  Future<void> _onDhikrSelected(DhikrModel dhikr) async {
    setState(() {
      _selectedDhikr = dhikr;
    });
  }

  Future<void> _onDailyTargetsUpdated(Map<String, int> targets) async {
    await _dhikrService.saveDailyTargets(targets);
    setState(() {
      _dailyTargets = targets;
    });
  }

  Future<void> _handleRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Loading your dhikr...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Dhikr Selector
              SliverToBoxAdapter(
                child: DhikrSelectorWidget(
                  dhikrList: _dhikrList,
                  selectedDhikr: _selectedDhikr,
                  onDhikrSelected: _onDhikrSelected,
                ),
              ),
              
              // Tasbih Counter
              if (_selectedDhikr != null)
                SliverToBoxAdapter(
                  child: TasbihCounterWidget(
                    dhikr: _selectedDhikr!,
                    onCountUpdate: _onCountUpdate,
                  ),
                ),
              
              // Daily Targets
              SliverToBoxAdapter(
                child: DailyTargetsWidget(
                  dailyTargets: _dailyTargets,
                  onTargetsUpdated: _onDailyTargetsUpdated,
                ),
              ),
              
              // Bottom padding for navigation bar
              SliverToBoxAdapter(
                child: SizedBox(height: 12.h),
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
} 