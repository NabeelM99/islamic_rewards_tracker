import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/prayer_model.dart';
import '../../core/services/prayer_storage.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'widgets/daily_prayers_widget.dart';
import 'widgets/qaza_prayers_widget.dart';
import 'widgets/sunnah_prayers_widget.dart';
import 'widgets/prayer_statistics_widget.dart';

class PrayerTrackingScreen extends StatefulWidget {
  const PrayerTrackingScreen({super.key});

  @override
  State<PrayerTrackingScreen> createState() => _PrayerTrackingScreenState();
}

class _PrayerTrackingScreenState extends State<PrayerTrackingScreen>
    with TickerProviderStateMixin {
  final PrayerStorageService _prayerService = PrayerStorageService();
  late TabController _tabController;
  
  List<PrayerModel> _todayPrayers = [];
  List<PrayerModel> _qazaPrayers = [];
  List<SunnahPrayerModel> _sunnahPrayers = [];
  PrayerStatistics? _statistics;
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('PrayerTrackingScreen: initState called');
    _tabController = TabController(length: 4, vsync: this);
    print('PrayerTrackingScreen: About to call _loadData');
    _loadData();
    print('PrayerTrackingScreen: _loadData called');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      print('PrayerTrackingScreen: Starting to load data...');
      
      // Load data with timeout to prevent hanging
      List<PrayerModel> todayPrayers = [];
      List<PrayerModel> qazaPrayers = [];
      List<SunnahPrayerModel> sunnahPrayers = [];
      PrayerStatistics? statistics;
      
      try {
        print('PrayerTrackingScreen: Loading today prayers...');
        todayPrayers = await _prayerService.getPrayersForDate(_selectedDate)
            .timeout(const Duration(seconds: 5));
        print('PrayerTrackingScreen: Today prayers loaded: ${todayPrayers.length}');
      } catch (e) {
        print('PrayerTrackingScreen: Failed to load today prayers: $e');
        todayPrayers = [];
      }
      
      try {
        print('PrayerTrackingScreen: Loading qaza prayers...');
        qazaPrayers = await _prayerService.getQazaPrayers()
            .timeout(const Duration(seconds: 5));
        print('PrayerTrackingScreen: Qaza prayers loaded: ${qazaPrayers.length}');
      } catch (e) {
        print('PrayerTrackingScreen: Failed to load qaza prayers: $e');
        qazaPrayers = [];
      }
      
      try {
        print('PrayerTrackingScreen: Loading sunnah prayers...');
        sunnahPrayers = await _prayerService.getSunnahPrayersForDate(_selectedDate)
            .timeout(const Duration(seconds: 5));
        print('PrayerTrackingScreen: Sunnah prayers loaded: ${sunnahPrayers.length}');
      } catch (e) {
        print('PrayerTrackingScreen: Failed to load sunnah prayers: $e');
        sunnahPrayers = [];
      }
      
      // Load statistics separately to avoid blocking
      try {
        print('PrayerTrackingScreen: Loading statistics...');
        statistics = await _prayerService.getPrayerStatistics()
            .timeout(const Duration(seconds: 3));
        print('PrayerTrackingScreen: Statistics loaded successfully');
      } catch (e) {
        print('PrayerTrackingScreen: Failed to load statistics: $e');
        // Continue without statistics
      }
      
      print('PrayerTrackingScreen: All data loaded, updating UI...');
      
      if (mounted) {
        setState(() {
          _todayPrayers = todayPrayers;
          _qazaPrayers = qazaPrayers;
          _sunnahPrayers = sunnahPrayers;
          _statistics = statistics;
          _isLoading = false;
        });
        print('PrayerTrackingScreen: UI updated successfully');
      }
    } catch (e) {
      print('PrayerTrackingScreen: Error loading prayer data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onPrayerStatusUpdated(String prayerId, PrayerStatus status, {String? notes}) async {
    try {
      await _prayerService.updatePrayerStatus(prayerId, status, notes: notes);
      await _loadData();
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prayer status updated successfully!'),
            backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating prayer status: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onPrayerMarkedAsQaza(String prayerId) async {
    try {
      await _prayerService.markPrayerAsQaza(prayerId);
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prayer marked as Qaza successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking prayer as Qaza: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onQazaCompleted(String prayerId) async {
    try {
      await _prayerService.completeQazaPrayer(prayerId);
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Qaza prayer completed successfully!'),
            backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing Qaza prayer: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onSunnahUpdated(String sunnahId, int completedRakats, {String? notes}) async {
    try {
      await _prayerService.updateSunnahPrayer(sunnahId, completedRakats, notes: notes);
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sunnah prayer updated successfully!'),
            backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating Sunnah prayer: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDate = newDate;
      _isLoading = true;
    });
    await _loadData();
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
                  'Loading your prayers...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FooterNavigationWidget(
          currentRoute: AppRoutes.prayerTracking,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with date picker
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final newDate = _selectedDate.subtract(const Duration(days: 1));
                      _onDateChanged(newDate);
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showDatePicker(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: theme.colorScheme.primary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _formatDate(_selectedDate),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final newDate = _selectedDate.add(const Duration(days: 1));
                      _onDateChanged(newDate);
                    },
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: theme.cardColor,
              child: TabBar(
                controller: _tabController,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                indicatorColor: theme.colorScheme.primary,
                tabs: [
                  Tab(
                    icon: Icon(Icons.schedule_rounded, size: 5.w),
                    text: 'Daily',
                  ),
                  Tab(
                    icon: Icon(Icons.replay_rounded, size: 5.w),
                    text: 'Qaza',
                  ),
                  Tab(
                    icon: Icon(Icons.star_rounded, size: 5.w),
                    text: 'Sunnah',
                  ),
                  Tab(
                    icon: Icon(Icons.analytics_rounded, size: 5.w),
                    text: 'Stats',
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: theme.colorScheme.primary,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Daily Prayers Tab
                    DailyPrayersWidget(
                      prayers: _todayPrayers,
                      onPrayerStatusUpdated: _onPrayerStatusUpdated,
                      onPrayerMarkedAsQaza: _onPrayerMarkedAsQaza,
                    ),
                    
                    // Qaza Prayers Tab
                    QazaPrayersWidget(
                      qazaPrayers: _qazaPrayers,
                      onQazaCompleted: _onQazaCompleted,
                    ),
                    
                    // Sunnah Prayers Tab
                    SunnahPrayersWidget(
                      sunnahPrayers: _sunnahPrayers,
                      onSunnahUpdated: _onSunnahUpdated,
                    ),
                    
                    // Statistics Tab
                    PrayerStatisticsWidget(
                      statistics: _statistics,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigationWidget(
        currentRoute: AppRoutes.prayerTracking,
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selected = DateTime(date.year, date.month, date.day);
    
    if (selected == today) {
      return 'Today';
    } else if (selected == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 