import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/dhikr_model.dart';
import '../../../core/services/dhikr_storage.dart';
import '../../../theme/app_theme.dart';

class DhikrSelectorWidget extends StatefulWidget {
  final List<DhikrModel> dhikrList;
  final DhikrModel? selectedDhikr;
  final Function(DhikrModel) onDhikrSelected;

  const DhikrSelectorWidget({
    super.key,
    required this.dhikrList,
    required this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelectorWidget> createState() => _DhikrSelectorWidgetState();
}

class _DhikrSelectorWidgetState extends State<DhikrSelectorWidget> {
  final DhikrStorageService _dhikrService = DhikrStorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _arabicController = TextEditingController();
  final TextEditingController _transliterationController = TextEditingController();
  final TextEditingController _translationController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _arabicController.dispose();
    _transliterationController.dispose();
    _translationController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _showAddCustomDhikrDialog() {
    _titleController.clear();
    _arabicController.clear();
    _transliterationController.clear();
    _translationController.clear();
    _targetController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Custom Dhikr',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _arabicController,
                decoration: const InputDecoration(
                  labelText: 'Arabic Text (optional)',
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _transliterationController,
                decoration: const InputDecoration(
                  labelText: 'Transliteration (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _translationController,
                decoration: const InputDecoration(
                  labelText: 'Translation (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: 'Daily Target *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addCustomDhikr,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addCustomDhikr() async {
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and target are required')),
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

    final customDhikr = DhikrModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      arabicText: _arabicController.text.isNotEmpty ? _arabicController.text : null,
      transliteration: _transliterationController.text.isNotEmpty ? _transliterationController.text : null,
      translation: _translationController.text.isNotEmpty ? _translationController.text : null,
      targetCount: target,
      isCustom: true,
      category: 'Custom',
    );

    await _dhikrService.saveDhikr(customDhikr);
    
    Navigator.pop(context);
    
    // Refresh the parent widget
    if (mounted) {
      setState(() {});
    }
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
                'Select Dhikr',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddCustomDhikrDialog,
                icon: Icon(Icons.add_rounded, size: 4.w),
                label: Text(
                  'Custom',
                  style: theme.textTheme.labelMedium,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.dhikrList.length,
              itemBuilder: (context, index) {
                final dhikr = widget.dhikrList[index];
                final isSelected = widget.selectedDhikr?.id == dhikr.id;
                
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: ChoiceChip(
                    label: Text(
                      dhikr.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected ? theme.colorScheme.onPrimary : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        widget.onDhikrSelected(dhikr);
                      }
                    },
                    backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.1),
                    selectedColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 