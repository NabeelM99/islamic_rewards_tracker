import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/progress_card_widget.dart';
import './widgets/summary_stats_widget.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../core/services/task_storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  bool isCalendarView = false;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final Map<DateTime, Map<String, dynamic>> historyData = {};
  final Map<DateTime, int> completionData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistoryFromStorage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryFromStorage() async {
    final dates = await TaskStorage.loadHistoryDates();
    historyData.clear();
    completionData.clear();
    for (final date in dates) {
      final tasks = await TaskStorage.loadDayTasks(date);
      final summary = TaskStorage.summarizeTasks(tasks);
      final completed = summary['completed'] ?? 0;
      final total = summary['total'] ?? 0;
      final pct = total > 0 ? (completed / total * 100).round() : 0;
      final key = DateTime(date.year, date.month, date.day);
      historyData[key] = {
        'tasks': tasks,
        'completedTasks': completed,
        'totalTasks': total,
        'completionPercentage': pct,
      };
      completionData[key] = pct;
    }
    if (mounted) setState(() {});
  }

  Map<String, dynamic> _getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));

    int totalTasks = 0;
    int completedTasks = 0;
    int streak = 0;

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayData = historyData[dateKey];

      if (dayData != null) {
        totalTasks += dayData['totalTasks'] as int;
        completedTasks += dayData['completedTasks'] as int;

        if ((dayData['completionPercentage'] as int) >= 80) {
          streak++;
        }
      }
    }

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'streak': streak,
      'trend': completedTasks > totalTasks * 0.7 ? 'up' : 'stable',
    };
  }

  Map<String, dynamic> _getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    int totalTasks = 0;
    int completedTasks = 0;
    int streak = 0;

    for (int i = 0; i <= monthEnd.day - monthStart.day; i++) {
      final date = monthStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayData = historyData[dateKey];

      if (dayData != null) {
        totalTasks += dayData['totalTasks'] as int;
        completedTasks += dayData['completedTasks'] as int;

        if ((dayData['completionPercentage'] as int) >= 80) {
          streak++;
        }
      }
    }

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'streak': streak,
      'trend': completedTasks > totalTasks * 0.6 ? 'improving' : 'stable',
    };
  }

  List<DateTime> _getHistoryDates() {
    final dates = historyData.keys.toList();
    dates.sort((a, b) => b.compareTo(a)); // Sort in descending order
    return dates;
  }

  List<Map<String, dynamic>> _getSelectedDateTasks() {
    final dateKey = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final dayData = historyData[dateKey];
    return dayData != null ? List<Map<String, dynamic>>.from(dayData['tasks'] ?? []) : [];
  }

  Future<void> _refreshHistory() async {
    await _loadHistoryFromStorage();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDateTasks = _getSelectedDateTasks();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Date Picker
            DatePickerWidget(
              selectedDate: selectedDate,
              onDateChanged: _onDateSelected,
            ),

            // Summary Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: SummaryStatsWidget(
                weeklyStats: _getWeeklyStats(),
                monthlyStats: _getMonthlyStats(),
              ),
            ),

            // Main Content
            Expanded(
              child: selectedDateTasks.isEmpty
                  ? const EmptyStateWidget()
                  : Column(
                      children: [
                        // Toggle between list and calendar view
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Row(
                            children: [
                              Text(
                                'Your Progress',
                                style: theme.textTheme.titleLarge,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _toggleViewMode,
                                icon: Icon(
                                  isCalendarView
                                      ? Icons.list_rounded
                                      : Icons.calendar_month_rounded,
                                  size: 6.w,
                                ),
                                tooltip: isCalendarView
                                    ? 'List View'
                                    : 'Calendar View',
                              ),
                            ],
                          ),
                        ),

                        // Content based on view mode
                        Expanded(
                          child: isCalendarView
                              ? CalendarViewWidget(
                                  selectedDate: selectedDate,
                                  onDateSelected: _onDateSelected,
                                  completionData: completionData,
                                )
                              : RefreshIndicator(
                                  onRefresh: _refreshHistory,
                                  color: theme.colorScheme.primary,
                                  child: CustomScrollView(
                                    slivers: [
                                      // Progress Cards
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final dateKey = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                                            final dayData = historyData[dateKey];
                                            return ProgressCardWidget(
                                              date: selectedDate,
                                              totalTasks: dayData?['totalTasks'] ?? 0,
                                              completedTasks: dayData?['completedTasks'] ?? 0,
                                              taskDetails: selectedDateTasks,
                                            );
                                          },
                                          childCount: 1,
                                        ),
                                      ),

                                      // Bottom padding for navigation bar
                                      SliverToBoxAdapter(
                                        child: SizedBox(height: 16.h),
                                      ),
                                    ],
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
        currentRoute: AppRoutes.history,
      ),
    );
  }

  void _toggleViewMode() {
    setState(() {
      isCalendarView = !isCalendarView;
    });
  }
}