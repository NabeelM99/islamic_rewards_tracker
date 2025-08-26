import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/footer_navigation_widget.dart';
import './widgets/add_task_bottom_sheet.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/task_card_widget.dart';
import './widgets/task_details_bottom_sheet.dart';
import '../../core/services/task_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  String _islamicGreeting = '';
  DateTime _currentDate = DateTime.now();

  // Mock Islamic tasks data
  final List<Map<String, dynamic>> _mockTasks = [
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
      "dateCreated":
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
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
      "dateCreated":
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
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
      "dateCreated": DateTime.now().toIso8601String(),
    },
    {
      "id": "4",
      "arabicName": "الاستغفار",
      "englishName": "Istighfar (1000 times)",
      "transliteration": "Astaghfirullah",
      "description":
          "Seek Allah's forgiveness by saying 'Astaghfirullah' 1000 times daily.",
      "benefits":
          "Cleanses sins, opens doors of sustenance, and brings peace to the heart.",
      "type": "counter",
      "targetCount": 1000,
      "currentCount": 0,
      "isCompleted": false,
      "isCarryOver": false,
      "dateCreated": DateTime.now().toIso8601String(),
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
      "dateCreated": DateTime.now().toIso8601String(),
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
      "dateCreated": DateTime.now().toIso8601String(),
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
      "dateCreated": DateTime.now().toIso8601String(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadTasks();
    _setIslamicGreeting();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
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

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    // Try load persisted tasks for today
    List<Map<String, dynamic>> loadedTasks =
        await TaskStorage.loadTodayTasks();
    if (loadedTasks.isEmpty) {
      // First time today: seed with mock
      loadedTasks = List<Map<String, dynamic>>.from(_mockTasks);
      await TaskStorage.saveTodayTasks(loadedTasks);
    }

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
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _loadTasks();
    _setIslamicGreeting();
    setState(() => _currentDate = DateTime.now());
  }

  void _handleTaskToggle(String taskId, bool isCompleted) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex]['isCompleted'] = isCompleted;
        if (isCompleted) {
          HapticFeedback.mediumImpact();
        }
      }
    });
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
  }

  void _handleCounterUpdate(String taskId, int count) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex]['currentCount'] = count;
        final targetCount = _tasks[taskIndex]['targetCount'] ?? 1;
        _tasks[taskIndex]['isCompleted'] = count >= targetCount;

        if (count >= targetCount) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }
    });
    TaskStorage.saveTodayTasks(_tasks);
    TaskStorage.saveHistorySnapshot(DateTime.now(), _tasks);
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
  }

  void _handleNavigation(String route) {
    print('Navigation requested to: $route');
    try {
      Navigator.pushNamed(context, route);
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

  bool _areAllTasksCompleted() {
    return _tasks.isNotEmpty &&
        _tasks.every((task) => task['isCompleted'] == true);
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
                              if (_areAllTasksCompleted())
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
                                    child: EmptyStateWidget(
                                      onAddTask: _showAddTaskSheet,
                                    ),
                                  ),
                                ),
                              // Tasks List
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final task = _tasks[index];
                                    return TaskCardWidget(
                                      task: task,
                                      onTaskToggle: _handleTaskToggle,
                                      onCounterUpdate: _handleCounterUpdate,
                                      onTaskDetails: () => _showTaskDetails(task),
                                    );
                                  },
                                  childCount: _tasks.length,
                                ),
                              ),

                              // Bottom padding for navigation bar
                              SliverToBoxAdapter(
                                child: SizedBox(height: 12.h),
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
      bottomNavigationBar: FooterNavigationWidget(
        currentRoute: AppRoutes.home,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
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
            'Loading your tasks...',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
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

  Widget _buildTasksList() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 2.h,
          bottom: 12.h, // Space for FAB
        ),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return TaskCardWidget(
            task: task,
            onTaskToggle: _handleTaskToggle,
            onCounterUpdate: _handleCounterUpdate,
            onTaskDetails: () => _showTaskDetails(task),
          );
        },
      ),
    );
  }
}