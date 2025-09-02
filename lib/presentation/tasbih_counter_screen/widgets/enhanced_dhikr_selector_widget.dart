import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/dhikr_model.dart';
import '../../../core/services/dhikr_storage.dart';
import '../../../theme/app_theme.dart';

class EnhancedDhikrSelectorWidget extends StatefulWidget {
  final List<DhikrModel> dhikrList;
  final DhikrModel? selectedDhikr;
  final Function(DhikrModel) onDhikrSelected;

  const EnhancedDhikrSelectorWidget({
    super.key,
    required this.dhikrList,
    required this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<EnhancedDhikrSelectorWidget> createState() => _EnhancedDhikrSelectorWidgetState();
}

class _EnhancedDhikrSelectorWidgetState extends State<EnhancedDhikrSelectorWidget> {
  final DhikrStorageService _dhikrService = DhikrStorageService();
  final TextEditingController _arabicController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  @override
  void dispose() {
    _arabicController.dispose();
    _meaningController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _showAddNewDhikrDialog() {
    _arabicController.clear();
    _meaningController.clear();
    _targetController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Dhikr'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _arabicController,
              decoration: const InputDecoration(
                labelText: 'Arabic Text *',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
              maxLines: 2,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _meaningController,
              decoration: const InputDecoration(
                labelText: 'Meaning *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Target Count *',
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
            onPressed: _addNewDhikr,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewDhikr() async {
    if (_arabicController.text.isEmpty || 
        _meaningController.text.isEmpty || 
        _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
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

    final newDhikr = DhikrModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _meaningController.text,
      arabicText: _arabicController.text,
      targetCount: target,
      isCustom: true,
      category: 'Custom',
    );

    await _dhikrService.saveDhikr(newDhikr);
    
    Navigator.pop(context);
    
    // Refresh the parent widget
    if (mounted) {
      setState(() {});
    }
  }

  void _showDhikrSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            SizedBox(height: 1.5.h),
            
            // Title and Add Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select a Dhikr',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddNewDhikrDialog,
                    icon: Icon(Icons.add, size: 2.5.w),
                    label: Text(
                      'Add New',
                      style: TextStyle(fontSize: 9.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.8.h),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 1.5.h),
            
            // Dhikr list
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(2.w),
                  itemCount: widget.dhikrList.length,
                  itemBuilder: (context, index) {
                    final dhikr = widget.dhikrList[index];
                    final isSelected = widget.selectedDhikr?.id == dhikr.id;
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.onDhikrSelected(dhikr);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.all(2.5.w),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 1.5,
                              ) : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dhikr.arabicText != null) ...[
                                  Text(
                                    dhikr.arabicText!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.lightTheme.colorScheme.primary,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 0.5.h),
                                ],
                                Text(
                                  dhikr.title,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Dhikr display area
          GestureDetector(
            onTap: _showDhikrSelectionDialog,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: widget.selectedDhikr != null
                        ? widget.selectedDhikr!.arabicText != null
                            ? Text(
                                widget.selectedDhikr!.arabicText!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                  height: 1.8,
                                ),
                                textDirection: TextDirection.rtl,
                              )
                            : Text(
                                'TAP TO SELECT DHIKR',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              )
                        : Text(
                            'TAP TO SELECT DHIKR',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  if (widget.selectedDhikr != null) ...[
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: _showDhikrSelectionDialog,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 4.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
} 