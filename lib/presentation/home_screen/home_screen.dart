import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../core/services/task_storage.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/task_notification_manager.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/smooth_navigation.dart';
import '../../widgets/smooth_button_widget.dart';
import './widgets/add_task_bottom_sheet.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/task_card_widget.dart';
import './widgets/task_details_bottom_sheet.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  Timer? _dailyResetTimer;

  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  String _islamicGreeting = '';
  DateTime _currentDate = DateTime.now();
  
  // Cache for expensive calculations
  bool _areAllTasksCompleted = false;
  int _completedTasksCount = 0;
  int _totalTasksCount = 0;
  int _customTasksCount = 0;

  // Mock Islamic tasks data - moved to static const for better performance
  static const List<Map<String, dynamic>> _mockTasks = [
    {
      "id": "1",
      "arabicName": "أذكار الصباح",
      "englishName": "Morning Adhkar",
      "transliteration": "Adhkar as-Sabah",
      "description":
          "Recite the morning remembrance of Allah to start your day with blessings and protection.",
      "benefits":
          "Provides spiritual protection, increases faith, and brings barakah to your day.",
      "type": "checkbox",
      "targetCount": 1,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": false,
      "dateCreated": null, // Will be set dynamically
    },
    {
      "id": "2",
      "arabicName": "أذكار المساء",
      "englishName": "Evening Adhkar",
      "transliteration": "Adhkar al-Masa'",
      "description":
          "Recite the evening remembrance of Allah for protection during the night.",
      "benefits":
          "Seeks Allah's protection during sleep and brings peace to the heart.",
      "type": "checkbox",
      "targetCount": 1,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": true,
      "dateCreated": null, // Will be set dynamically
    },
    {
      "id": "3",
      "arabicName": "تلاوة القرآن",
      "englishName": "Qur'an Recitation (100 verses)",
      "transliteration": "Tilawat al-Qur'an",
      "description":
          "Recite 100 verses from the Holy Qur'an to earn immense rewards.",
      "benefits":
          "Each letter brings 10 rewards, purifies the heart, and increases knowledge.",
      "type": "counter",
      "targetCount": 100,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": false,
      "dateCreated": null, // Will be set dynamically
    },
    {
      "id": "5",
      "arabicName": "الصدقة",
      "englishName": "Daily Charity",
      "transliteration": "Sadaqah",
      "description":
          "Give charity, even if it's a small amount, to help those in need.",
      "benefits":
          "Purifies wealth, increases barakah, and earns Allah's pleasure.",
      "type": "checkbox",
      "targetCount": 1,
      "currentCount": 0,
      "isCompleted": true,
      "isCarryOver": false,
      "dateCreated": null, // Will be set dynamically
    },
    {
      "id": "6",
      "arabicName": "قراءة كتاب إسلامي",
      "englishName": "Islamic Book Reading",
      "transliteration": "Qira'at Kitab Islami",
      "description":
          "Read from an Islamic book to increase your knowledge of the religion.",
      "benefits":
          "Increases Islamic knowledge, strengthens faith, and guides to righteous actions.",
      "type": "checkbox",
      "targetCount": 1,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": false,
      "dateCreated": null, // Will be set dynamically
    },
    {
      "id": "7",
      "arabicName": "دراسة السيرة النبوية",
      "englishName": "Seerah Study",
      "transliteration": "Dirasat as-Seerah an-Nabawiyyah",
      "description":
          "Study the life and teachings of Prophet Muhammad (peace be upon him).",
      "benefits":
          "Learn from the best example, increases love for the Prophet, and guides behavior.",
      "type": "checkbox",
      "targetCount": 1,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": false,
      "dateCreated": null, // Will be set dynamically
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _loadTasks();
    _setIslamicGreeting();
    _startDailyResetTimer();
    _initializeNotificationManager();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fabAnimationController.dispose();
    _dailyResetTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, check for daily reset
      _checkForDailyReset();
    }
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _setIslamicGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _islamicGreeting = 'صباح الخير - Good Morning';
    } else if (hour < 17) {
      _islamicGreeting = 'السلام عليكم - Peace be upon you';
    } else {
      _islamicGreeting = 'مساء الخير - Good Evening';
    }
  }

  void _startDailyResetTimer() {
    // Check for daily reset every minute
    _dailyResetTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForDailyReset();
    });
  }

  Future<void> _initializeNotificationManager() async {
    await TaskNotificationManager().initialize();
  }

  void _checkForDailyReset() {
    final now = DateTime.now();
    final currentDay = DateTime(now.year, now.month, now.day);
    final storedDay = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    
    // If it's a new day, save current progress to history and reload tasks
    if (currentDay.isAfter(storedDay)) {
      // Save the previous day's progress to history
      if (_tasks.isNotEmpty) {
        TaskStorage.saveHistorySnapshot(_currentDate, _tasks);
      }
      
      setState(() {
        _currentDate = now;
      });
      _setIslamicGreeting();
      _loadTasks();
      
      // Show notification for new day
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New day started! Your tasks have been reset.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Clean up old history data once a week (on Sundays)
      if (now.weekday == DateTime.sunday) {
        TaskStorage.cleanupOldHistory();
      }
    }
  }

  // Memoized method to update task statistics
  void _updateTaskStatistics() {
    final newTotalTasksCount = _tasks.length;
    final newCompletedTasksCount = _tasks.where((task) => task['isCompleted'] == true).length;
    final newAreAllTasksCompleted = newTotalTasksCount > 0 && newCompletedTasksCount == newTotalTasksCount;
    final newCustomTasksCount = _tasks.where((task) {
      final taskId = task['id']?.toString();
      return !_mockTasks.any((defaultTask) => defaultTask['id'] == taskId);
    }).length;
    
    // Only update if values have changed to avoid unnecessary rebuilds
    if (_totalTasksCount != newTotalTasksCount || 
        _completedTasksCount != newCompletedTasksCount || 
        _areAllTasksCompleted != newAreAllTasksCompleted ||
        _customTasksCount != newCustomTasksCount) {
      setState(() {
        _totalTasksCount = newTotalTasksCount;
        _completedTasksCount = newCompletedTasksCount;
        _areAllTasksCompleted = newAreAllTasksCompleted;
        _customTasksCount = newCustomTasksCount;
      });
    }
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    // Load tasks with daily reset check
    List<Map<String, dynamic>> loadedTasks =
        await TaskStorage.loadTodayTasksWithReset(_mockTasks);
    
    // If still empty (shouldn't happen with the new method), fallback to mock tasks
    if (loadedTasks.isEmpty) {
      loadedTasks = List<Map<String, dynamic>>.from(_mockTasks);
      await TaskStorage.saveTodayTasks(loadedTasks);
    }

    // Filter out any istighfar counter tasks that might be in stored data
    loadedTasks = loadedTasks.where((task) {
      final englishName = task['englishName']?.toString().toLowerCase() ?? '';
      final arabicName = task['arabicName']?.toString() ?? '';
      final transliteration = task['transliteration']?.toString().toLowerCase() ?? '';
      final targetCount = task['targetCount'] ?? 1;
      
      // Remove only istighfar counter tasks (1000 times), keep checkbox tasks
      if (englishName.contains('istighfar (1000)') || 
          arabicName.contains('استغفار') || 
          transliteration.contains('astaghfirullah')) {
        // Keep if it's a checkbox task, remove if it's a counter with high target
        return task['type'] == 'checkbox' || targetCount <= 100;
      }
      
      return true;
    }).toList();

    // Sort tasks: carryover first, then by completion status
    loadedTasks.sort((a, b) {
      final aCarryOver = a['isCarryOver'] ?? false;
      final bCarryOver = b['isCarryOver'] ?? false;
      final aCompleted = a['isCompleted'] ?? false;
      final bCompleted = b['isCompleted'] ?? false;

      if (aCarryOver && !bCarryOver) return -1;
      if (!aCarryOver && bCarryOver) return 1;
      if (aCompleted && !bCompleted) return 1;
      if (!aCompleted && bCompleted) return -1;
      return 0;
    });

    setState(() {
      _tasks = loadedTasks;
      _isLoading = false;
    });
    
    // Update statistics after state change
    _updateTaskStatistics();
  }

  void _handleDeleteCustomTask(String taskId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Task'),
        content: const Text('Are you sure you want to delete this custom task? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() {
      _tasks.removeWhere((task) => (task['id']?.toString()) == taskId);
    });
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
    _updateTaskStatistics();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _loadTasks();
    _setIslamicGreeting();
    setState(() => _currentDate = DateTime.now());
  }

  // Manual reset for today's tasks (useful for testing or user preference)
  Future<void> _resetTodayTasks() async {
    // Show confirmation dialog
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Today\'s Tasks'),
        content: const Text('Are you sure you want to reset all tasks for today? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset != true) return;

    // Save current progress to history first
    if (_tasks.isNotEmpty) {
      TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
    }
    
    // Force reset for today
    await TaskStorage.forceResetForToday(_mockTasks);
    
    // Reload tasks
    await _loadTasks();
    
    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tasks reset for today'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleTaskToggle(String taskId, bool isCompleted) async {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex]['isCompleted'] = isCompleted;
        if (isCompleted) {
          HapticFeedback.mediumImpact();
        }
        
        // Re-sort tasks after completion status changes
        _tasks.sort((a, b) {
          final aCarryOver = a['isCarryOver'] ?? false;
          final bCarryOver = b['isCarryOver'] ?? false;
          final aCompleted = a['isCompleted'] ?? false;
          final bCompleted = b['isCompleted'] ?? false;

          if (aCarryOver && !bCarryOver) return -1;
          if (!aCarryOver && bCarryOver) return 1;
          if (aCompleted && !bCompleted) return 1;
          if (!aCompleted && bCompleted) return -1;
          return 0;
        });
      }
    });
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
    
    // Update notification schedule when task is completed
    if (isCompleted) {
      await TaskNotificationManager().markTaskCompleted(taskId);
    }
    
    // Update statistics after state change
    _updateTaskStatistics();
  }

  void _handleCounterUpdate(String taskId, int count) async {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex]['currentCount'] = count;
        final targetCount = _tasks[taskIndex]['targetCount'] ?? 1;
        final wasCompleted = _tasks[taskIndex]['isCompleted'] ?? false;
        _tasks[taskIndex]['isCompleted'] = count >= targetCount;

        if (count >= targetCount) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
        
        // Re-sort tasks after completion status changes
        _tasks.sort((a, b) {
          final aCarryOver = a['isCarryOver'] ?? false;
          final bCarryOver = b['isCarryOver'] ?? false;
          final aCompleted = a['isCompleted'] ?? false;
          final bCompleted = b['isCompleted'] ?? false;

          if (aCarryOver && !bCarryOver) return -1;
          if (!aCarryOver && bCarryOver) return 1;
          if (aCompleted && !bCompleted) return 1;
          if (!aCompleted && bCompleted) return -1;
          return 0;
        });
      }
    });
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
    
    // Update notification schedule when task is newly completed
    final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
    if (taskIndex != -1) {
      final wasCompleted = _tasks[taskIndex]['isCompleted'] ?? false;
      final isNowCompleted = count >= (_tasks[taskIndex]['targetCount'] ?? 1);
      
      if (isNowCompleted && !wasCompleted) {
        await TaskNotificationManager().markTaskCompleted(taskId);
      }
    }
    
    // Update statistics after state change
    _updateTaskStatistics();
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailsBottomSheet(task: task),
    );
  }

  void _showAddTaskSheet() {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomSheet(
        onTaskAdd: _handleAddTask,
      ),
    );
  }

  void _handleAddTask(Map<String, dynamic> newTask) {
    setState(() {
      _tasks.add(newTask);
    });
    HapticFeedback.mediumImpact();
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
    
    // Update statistics after state change
    _updateTaskStatistics();
  }

  void _handleNavigation(String route) {
    print('Navigation requested to: $route');
    try {
      if (route == 'favorites') {
        // Navigate to favorites screen with smooth transition
        context.smoothPushNamed('/favorites-screen');
      } else {
        context.smoothPushNamed(route);
      }
      print('Navigation successful');
    } catch (e) {
      print('Navigation error: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Date Header
            DateHeaderWidget(
              currentDate: _currentDate,
              islamicGreeting: _islamicGreeting,
              onNavigate: _handleNavigation,
              onReset: _resetTodayTasks,
              customTasksCount: _customTasksCount,
            ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : (_tasks.isEmpty
                      ? _buildEmptyTasksState()
                      : RefreshIndicator(
                          onRefresh: _handleRefresh,
                          color: theme.colorScheme.primary,
                          child: CustomScrollView(
                            slivers: [
                              if (_areAllTasksCompleted)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 2, left: 4, right: 4),
                                    child: EmptyStateWidget(
                                      onAddTask: _showAddTaskSheet,
                                    ),
                                  ),
                                ),
                              // Tasks List - Optimized with SliverList
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final task = _tasks[index];
                                    return TaskCardWidget(
                                      key: ValueKey('task_${task['id']}'), // Add key for better performance
                                      task: task,
                                      onTaskToggle: _handleTaskToggle,
                                      onCounterUpdate: _handleCounterUpdate,
                                      onTaskDetails: () => _showTaskDetails(task),
                                      onDeleteCustomTask: (id) => _handleDeleteCustomTask(id),
                                      isCustomTask: !_mockTasks.any((defaultTask) => defaultTask['id'] == task['id']),
                                    );
                                  },
                                  childCount: _tasks.length,
                                ),
                              ),

                              // Bottom padding for navigation bar
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 12),
                              ),
                            ],
                          ),
                        )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        child: Icon(
          Icons.add_rounded,
          size: 6.w,
        ),
      ),
      bottomNavigationBar: const FooterNavigationWidget(
        currentRoute: AppRoutes.home,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 3),
          Text(
            'Loading your tasks...',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasksState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 20.w,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Tasks Yet',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Start your Islamic journey by adding your first daily task',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}