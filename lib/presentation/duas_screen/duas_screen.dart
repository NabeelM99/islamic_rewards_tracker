import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_search_widget.dart';
import './widgets/search_bar_widget.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/smooth_navigation.dart';
import 'dua_list_screen.dart';
import '../../data/duas_repository.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({Key? key}) : super(key: key);

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredCategories = [];
  late List<Map<String, dynamic>> _duasCategories;

  @override
  void initState() {
    super.initState();
    _duasCategories = DuasRepository.instance.getCategories();
    _filteredCategories = List.from(_duasCategories);
    
    // Add listener to search controller for live search
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(_duasCategories);
      } else {
        _filteredCategories = _duasCategories.where((category) {
          // Search in category name and description
          final categoryMatch = (category['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (category['description'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());

          if (categoryMatch) return true;

          // Search in duas within the category
          final duas = (category['duas'] as List);
          final duaMatch = duas.any((dua) {
            final duaMap = dua as Map<String, dynamic>;
            return (duaMap['title'] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (duaMap['arabic'] as String).contains(query) ||
                (duaMap['transliteration'] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (duaMap['translation'] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase());
          });

          return duaMatch;
        }).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredCategories = List.from(_duasCategories);
    });
  }



  Future<void> _refreshDuas() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _filteredCategories = List.from(_duasCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        title: Text(
          'Dua & Adhkar',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Search Bar - Moved below header
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _clearSearch,
            ),
            
            SizedBox(height: 1.h), // Reduced spacing
            
            // Main Content
            Expanded(
              child: _filteredCategories.isEmpty &&
                      _searchController.text.isNotEmpty
                  ? EmptySearchWidget(searchQuery: _searchController.text)
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: Column(
                          children: [
                            // Category Cards - Beautiful grid layout with icons
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: double.infinity,
                              ),
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h), // Reduced padding
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.3,
                                  crossAxisSpacing: 3.w,
                                  mainAxisSpacing: 2.h, // Reduced spacing
                                ),
                                itemCount: _filteredCategories.length,
                                itemBuilder: (context, index) {
                                  final cat = _filteredCategories[index];
                                  return _buildCategoryCard(context, cat, theme);
                                },
                              ),
                            ),
                            
                            SizedBox(height: 6.h), // Further reduced bottom padding
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigationWidget(
        currentRoute: AppRoutes.duas,
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category, ThemeData theme) {
    final categoryName = category['name'] as String;
    final iconData = _getCategoryIcon(categoryName);
    final gradientColors = _getCategoryGradient(categoryName);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + ((category['id'] as int) * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                context.smoothPushNamed(
                  '/dua-list-screen',
                  arguments: {
                    'categoryName': categoryName,
                    'duas': (category['duas'] as List).cast<Map<String, dynamic>>(),
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DuaListScreen(
                            categoryName: categoryName,
                            duas: (category['duas'] as List).cast<Map<String, dynamic>>(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon with background
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              iconData,
                              size: 6.w,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Category name
                          Text(
                            categoryName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          // Dua count
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${(category['duas'] as List).length} duas',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 8.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'morning adhkar':
        return Icons.wb_sunny_rounded;
      case 'evening adhkar':
        return Icons.nightlight_round;
      case 'daily supplications':
        return Icons.access_time;
      case 'duas after salah':
        return Icons.person;
      case 'duas before sleep':
        return Icons.bedtime;
      case 'daily duas':
        return Icons.family_restroom;
      case '40 rabbana duas':
        return Icons.menu_book;
      case 'ruquiya':
        return Icons.local_fire_department;
      case 'all dua':
        return Icons.category;
      case 'hajj & umrah':
        return Icons.church;
      default:
        return Icons.category;
    }
  }

  List<Color> _getCategoryGradient(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'morning adhkar':
        return [Color(0xFFFF6B35), Color(0xFFFF8E53)];
      case 'evening adhkar':
        return [Color(0xFF6B73FF), Color(0xFF8B9FFF)];
      case 'daily supplications':
        return [Color(0xFF4ECDC4), Color(0xFF44A08D)];
      case 'duas after salah':
        return [Color(0xFF45B7D1), Color(0xFF96C93D)];
      case 'duas before sleep':
        return [Color(0xFF667eea), Color(0xFF764ba2)];
      case 'daily duas':
        return [Color(0xFFf093fb), Color(0xFFf5576c)];
      case '40 rabbana duas':
        return [Color(0xFF4facfe), Color(0xFF00f2fe)];
      case 'ruquiya':
        return [Color(0xFFfa709a), Color(0xFFfee140)];
      case 'all dua':
        return [Color(0xFFa8edea), Color(0xFFfed6e3)];
      case 'hajj & umrah':
        return [Color(0xFFffecd2), Color(0xFFfcb69f)];
      default:
        return [Color(0xFF667eea), Color(0xFF764ba2)];
    }
  }
}
