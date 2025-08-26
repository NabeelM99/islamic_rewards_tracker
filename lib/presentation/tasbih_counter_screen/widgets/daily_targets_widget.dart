import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/services/dhikr_storage.dart';
import '../../../theme/app_theme.dart';

class DailyTargetsWidget extends StatefulWidget {
  final Map<String, int> dailyTargets;
  final Function(Map<String, int>) onTargetsUpdated;

  const DailyTargetsWidget({
    super.key,
    required this.dailyTargets,
    required this.onTargetsUpdated,
  });

  @override
  State<DailyTargetsWidget> createState() => _DailyTargetsWidgetState();
}

class _DailyTargetsWidgetState extends State<DailyTargetsWidget> {
  final DhikrStorageService _dhikrService = DhikrStorageService();
  final TextEditingController _targetController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  void _showAddTargetDialog() {
    _targetController.clear();
    _selectedCategory = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Set Daily Target',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                'Morning & Evening',
                'General',
                'Custom',
                'All Dhikr',
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 3.h),
            TextField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Daily Target Count',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addDailyTarget,
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDailyTarget() async {
    if (_selectedCategory == null || _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category and enter target')),
      );
      return;
    }

    final target = int.tryParse(_targetController.text);
    if (target == null || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid target number')),
      );
      return;
    }

    final updatedTargets = Map<String, int>.from(widget.dailyTargets);
    updatedTargets[_selectedCategory!] = target;
    
    widget.onTargetsUpdated(updatedTargets);
    Navigator.pop(context);
  }

  void _removeTarget(String category) {
    final updatedTargets = Map<String, int>.from(widget.dailyTargets);
    updatedTargets.remove(category);
    widget.onTargetsUpdated(updatedTargets);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Targets',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddTargetDialog,
                icon: Icon(Icons.add_rounded, size: 4.w),
                label: Text(
                  'Add Target',
                  style: theme.textTheme.labelMedium,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          if (widget.dailyTargets.isEmpty)
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 10.w,
                      color: theme.colorScheme.outline,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No daily targets set',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Set targets to track your daily progress',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.dailyTargets.length,
              itemBuilder: (context, index) {
                final category = widget.dailyTargets.keys.elementAt(index);
                final target = widget.dailyTargets[category]!;
                
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Target: $target',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeTarget(category),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: theme.colorScheme.error,
                          size: 5.w,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
} 