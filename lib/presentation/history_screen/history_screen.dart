import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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
  final ScrollController _scrollController = ScrollController();

  final Map<DateTime, Map<String, dynamic>> historyData = {};

  @override
  void initState() {
    super.initState();
    _loadHistoryFromStorage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryFromStorage() async {
    final dates = await TaskStorage.loadHistoryDates();
    historyData.clear();
    
    for (final date in dates) {
      final tasks = await TaskStorage.loadDayTasks(date);
      final summary = TaskStorage.summarizeTasks(tasks);
      final completed = summary['completed'] ?? 0;
      final total = summary['total'] ?? 0;
      final pct = total > 0 ? (completed / total * 100).round() : 0;
      final key = DateTime(date.year, date.month, date.day);
      
      // Format tasks for display
      final formattedTasks = tasks.map((task) {
        final isCompleted = task['isCompleted'] ?? false;
        final currentCount = task['currentCount'] ?? 0;
        final targetCount = task['targetCount'] ?? 1;
        
        return {
          'id': task['id'],
          'name': task['englishName'] ?? task['name'] ?? 'Unknown Task',
          'arabicName': task['arabicName'],
          'type': task['type'],
          'isCompleted': isCompleted,
          'currentCount': currentCount,
          'targetCount': targetCount,
          'progress': currentCount,
          'target': targetCount,
        };
      }).toList();
      
      historyData[key] = {
        'tasks': formattedTasks,
        'completedTasks': completed,
        'totalTasks': total,
        'completionPercentage': pct,
      };
    }
    
    if (mounted) setState(() {});
  }

  Map<String, dynamic> _getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1)); // Start from Monday

    int totalTasks = 0;
    int completedTasks = 0;
    int daysWithData = 0;
    int streak = 0;

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayData = historyData[dateKey];

      if (dayData != null) {
        totalTasks += dayData['totalTasks'] as int;
        completedTasks += dayData['completedTasks'] as int;
        daysWithData++;

        if ((dayData['completionPercentage'] as int) >= 80) {
          streak++;
        }
      }
    }

    final averageCompletion = daysWithData > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'averageCompletion': averageCompletion,
      'daysWithData': daysWithData,
      'streak': streak,
      'trend': averageCompletion > 70 ? 'up' : averageCompletion > 50 ? 'stable' : 'down',
    };
  }

  Map<String, dynamic> _getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    int totalTasks = 0;
    int completedTasks = 0;
    int daysWithData = 0;
    int streak = 0;

    for (int i = 0; i <= monthEnd.day - monthStart.day; i++) {
      final date = monthStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayData = historyData[dateKey];

      if (dayData != null) {
        totalTasks += dayData['totalTasks'] as int;
        completedTasks += dayData['completedTasks'] as int;
        daysWithData++;

        if ((dayData['completionPercentage'] as int) >= 80) {
          streak++;
        }
      }
    }

    final averageCompletion = daysWithData > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'averageCompletion': averageCompletion,
      'daysWithData': daysWithData,
      'streak': streak,
      'trend': averageCompletion > 60 ? 'improving' : averageCompletion > 40 ? 'stable' : 'needs_improvement',
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
    final hasDataForSelectedDate = historyData.containsKey(DateTime(selectedDate.year, selectedDate.month, selectedDate.day));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        title: Text(
          'History',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshHistory,
            icon: Icon(
              Icons.refresh_rounded,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            tooltip: 'Refresh History',
          ),
        ],
      ),
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
              child: hasDataForSelectedDate
                  ? RefreshIndicator(
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
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: EmptyStateWidget(),
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

  String _formatSelectedDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      _onDateSelected(picked);
    }
  }
}