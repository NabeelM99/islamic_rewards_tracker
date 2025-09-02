import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/smooth_navigation.dart';
import '../../theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favoriteDuas = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteDuas();
  }

  void _loadFavoriteDuas() {
    // Mock favorite duas - in real app, load from local storage
    _favoriteDuas = [
      {
        "id": 1,
        "title": "Ayat al-Kursi",
        "arabic":
            "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ",
        "transliteration":
            "Allahu la ilaha illa huwa al-hayyu al-qayyum, la ta'khudhuhu sinatun wa la nawm",
        "translation":
            "Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep.",
        "category": "Morning Adhkar"
      },
      {
        "id": 6,
        "title": "Before eating",
        "arabic": "بِسْمِ اللَّهِ",
        "transliteration": "Bismillah",
        "translation": "In the name of Allah.",
        "category": "Daily Supplications"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        title: Text('Favorites'),
      ),
      body: SafeArea(
        child: _favoriteDuas.isEmpty
            ? _buildEmptyState()
            : _buildFavoritesList(),
      ),
      bottomNavigationBar: FooterNavigationWidget(
        currentRoute: AppRoutes.favorites,
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 15.w,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(height: 3.h),
          Text(
            'No Favorites Yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add duas to your favorites to see them here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.duas);
            },
            child: Text('Browse Duas'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _favoriteDuas.length,
      separatorBuilder: (_, __) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final dua = _favoriteDuas[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              final normalized = {
                'id': dua['id'],
                'title': dua['title'],
                'arabicTitle': dua['arabicTitle'] ?? '',
                'category': dua['category'] ?? '',
                'arabic': dua['arabic'] ?? '',
                'transliteration': dua['transliteration'] ?? '',
                'translation': dua['translation'] ?? '',
                'reference': dua['reference'] ?? '',
                'benefits': dua['benefits'] ?? '',
              };
              context.smoothPushNamed(
                '/dua-detail-screen',
                arguments: normalized,
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dua['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    dua['arabic'] as String,
                    style: IndoPakFonts.getArabicTextStyle(
                      fontSize: theme.textTheme.bodyLarge?.fontSize,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    dua['transliteration'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    dua['translation'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dua['category'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 