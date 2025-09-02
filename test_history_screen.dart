// Test file to demonstrate history screen functionality
// This is not a formal test, just a demonstration

import 'dart:async';
import 'package:flutter/material.dart';

// Mock data for testing history screen
class MockHistoryData {
  static Map<DateTime, Map<String, dynamic>> generateMockHistory() {
    final now = DateTime.now();
    final history = <DateTime, Map<String, dynamic>>{};
    
    // Generate data for the last 30 days
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      
      // Random completion data
      final totalTasks = 7;
      final completedTasks = (i % 3 == 0) ? totalTasks : (i % 5 == 0) ? 5 : (i % 7 == 0) ? 3 : 0;
      final completionPercentage = totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;
      
      // Mock tasks
      final tasks = [
        {
          'id': '1',
          'name': 'Morning Adhkar',
          'arabicName': 'أذكار الصباح',
          'type': 'checkbox',
          'isCompleted': completedTasks >= 1,
          'currentCount': completedTasks >= 1 ? 1 : 0,
          'targetCount': 1,
        },
        {
          'id': '2',
          'name': 'Evening Adhkar',
          'arabicName': 'أذكار المساء',
          'type': 'checkbox',
          'isCompleted': completedTasks >= 2,
          'currentCount': completedTasks >= 2 ? 1 : 0,
          'targetCount': 1,
        },
        {
          'id': '3',
          'name': 'Quran Recitation',
          'arabicName': 'تلاوة القرآن',
          'type': 'counter',
          'isCompleted': completedTasks >= 3,
          'currentCount': completedTasks >= 3 ? 100 : (completedTasks >= 2 ? 50 : 0),
          'targetCount': 100,
        },
        {
          'id': '4',
          'name': 'Istighfar',
          'arabicName': 'الاستغفار',
          'type': 'counter',
          'isCompleted': completedTasks >= 4,
          'currentCount': completedTasks >= 4 ? 1000 : (completedTasks >= 3 ? 500 : 0),
          'targetCount': 1000,
        },
        {
          'id': '5',
          'name': 'Daily Charity',
          'arabicName': 'الصدقة',
          'type': 'checkbox',
          'isCompleted': completedTasks >= 5,
          'currentCount': completedTasks >= 5 ? 1 : 0,
          'targetCount': 1,
        },
        {
          'id': '6',
          'name': 'Islamic Book Reading',
          'arabicName': 'قراءة كتاب إسلامي',
          'type': 'checkbox',
          'isCompleted': completedTasks >= 6,
          'currentCount': completedTasks >= 6 ? 1 : 0,
          'targetCount': 1,
        },
        {
          'id': '7',
          'name': 'Seerah Study',
          'arabicName': 'دراسة السيرة النبوية',
          'type': 'checkbox',
          'isCompleted': completedTasks >= 7,
          'currentCount': completedTasks >= 7 ? 1 : 0,
          'targetCount': 1,
        },
      ];
      
      history[dateKey] = {
        'tasks': tasks,
        'completedTasks': completedTasks,
        'totalTasks': totalTasks,
        'completionPercentage': completionPercentage,
      };
    }
    
    return history;
  }
  
  static Map<String, dynamic> calculateWeeklyStats(Map<DateTime, Map<String, dynamic>> history) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1)); // Start from Monday
    
    int totalTasks = 0;
    int completedTasks = 0;
    int daysWithData = 0;
    int streak = 0;
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayData = history[dateKey];
      
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
  
  static Map<String, dynamic> calculateMonthlyStats(Map<DateTime, Map<String, dynamic>> history) {
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
      final dayData = history[dateKey];
      
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
}

// Example usage
void main() async {
  print('Testing History Screen functionality...\n');
  
  // Generate mock history data
  final historyData = MockHistoryData.generateMockHistory();
  print('Generated history data for ${historyData.length} days\n');
  
  // Calculate weekly stats
  final weeklyStats = MockHistoryData.calculateWeeklyStats(historyData);
  print('Weekly Statistics:');
  print('  Total Tasks: ${weeklyStats['totalTasks']}');
  print('  Completed Tasks: ${weeklyStats['completedTasks']}');
  print('  Average Completion: ${weeklyStats['averageCompletion']}%');
  print('  Days with Data: ${weeklyStats['daysWithData']}');
  print('  Streak: ${weeklyStats['streak']} days');
  print('  Trend: ${weeklyStats['trend']}\n');
  
  // Calculate monthly stats
  final monthlyStats = MockHistoryData.calculateMonthlyStats(historyData);
  print('Monthly Statistics:');
  print('  Total Tasks: ${monthlyStats['totalTasks']}');
  print('  Completed Tasks: ${monthlyStats['completedTasks']}');
  print('  Average Completion: ${monthlyStats['averageCompletion']}%');
  print('  Days with Data: ${monthlyStats['daysWithData']}');
  print('  Streak: ${monthlyStats['streak']} days');
  print('  Trend: ${monthlyStats['trend']}\n');
  
  // Show sample day data
  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  final todayData = historyData[todayKey];
  
  if (todayData != null) {
    print('Today\'s Progress:');
    print('  Completed: ${todayData['completedTasks']}/${todayData['totalTasks']} tasks');
    print('  Completion: ${todayData['completionPercentage']}%');
    print('  Tasks:');
    final tasks = todayData['tasks'] as List;
    for (final task in tasks) {
      final isCompleted = task['isCompleted'] as bool;
      final name = task['name'] as String;
      final progress = task['currentCount'] as int;
      final target = task['targetCount'] as int;
      final status = isCompleted ? '✓' : progress > 0 ? '○' : '✗';
      print('    $status $name ($progress/$target)');
    }
  }
  
  print('\nHistory screen test completed!');
} 