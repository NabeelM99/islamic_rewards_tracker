// Test file to demonstrate daily reset functionality
// This is not a formal test, just a demonstration

import 'dart:async';
import 'package:flutter/material.dart';

// Mock TaskStorage for testing
class MockTaskStorage {
  static DateTime? lastResetDate;
  static List<Map<String, dynamic>> currentTasks = [];
  
  static Future<bool> isNewDay() async {
    final now = DateTime.now();
    
    if (lastResetDate == null) {
      lastResetDate = now;
      return true;
    }
    
    final isNewDay = now.year != lastResetDate!.year || 
                     now.month != lastResetDate!.month || 
                     now.day != lastResetDate!.day;
    
    if (isNewDay) {
      lastResetDate = now;
    }
    
    return isNewDay;
  }
  
  static Future<void> resetForNewDay(List<Map<String, dynamic>> defaultTasks) async {
    currentTasks = defaultTasks.map((task) {
      return {
        ...task,
        'currentCount': 0,
        'isCompleted': false,
      };
    }).toList();
  }
  
  static Future<List<Map<String, dynamic>>> loadTasksWithReset(List<Map<String, dynamic>> defaultTasks) async {
    final newDay = await isNewDay();
    
    if (newDay) {
      await resetForNewDay(defaultTasks);
    }
    
    return currentTasks;
  }
}

// Example usage
void main() async {
  // Mock default tasks
  final defaultTasks = [
    {
      'id': '1',
      'name': 'Morning Adhkar',
      'type': 'checkbox',
      'isCompleted': false,
    },
    {
      'id': '2', 
      'name': 'Quran Recitation',
      'type': 'counter',
      'currentCount': 0,
      'targetCount': 100,
      'isCompleted': false,
    },
  ];
  
  print('Testing daily reset functionality...\n');
  
  // Simulate first load
  print('1. First load of the day:');
  var tasks = await MockTaskStorage.loadTasksWithReset(defaultTasks);
  print('   Tasks loaded: ${tasks.length}');
  print('   Tasks completed: ${tasks.where((t) => t['isCompleted'] == true).length}\n');
  
  // Simulate completing some tasks
  print('2. Completing some tasks:');
  tasks[0]['isCompleted'] = true;
  tasks[1]['currentCount'] = 50;
  print('   Morning Adhkar completed: ${tasks[0]['isCompleted']}');
  print('   Quran verses read: ${tasks[1]['currentCount']}\n');
  
  // Simulate same day reload (should not reset)
  print('3. Reloading same day (should not reset):');
  tasks = await MockTaskStorage.loadTasksWithReset(defaultTasks);
  print('   Morning Adhkar still completed: ${tasks[0]['isCompleted']}');
  print('   Quran verses still at: ${tasks[1]['currentCount']}\n');
  
  // Simulate next day (should reset)
  print('4. Simulating next day (should reset):');
  // Manually set last reset date to yesterday
  MockTaskStorage.lastResetDate = DateTime.now().subtract(Duration(days: 1));
  tasks = await MockTaskStorage.loadTasksWithReset(defaultTasks);
  print('   Morning Adhkar reset: ${tasks[0]['isCompleted']}');
  print('   Quran verses reset: ${tasks[1]['currentCount']}\n');
  
  print('Daily reset test completed!');
} 