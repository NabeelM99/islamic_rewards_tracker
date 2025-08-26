import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/dua_category_card.dart';
import './widgets/empty_search_widget.dart';
import './widgets/favorites_section.dart';
import './widgets/search_bar_widget.dart';
import '../../widgets/footer_navigation_widget.dart';
import '../../routes/app_routes.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({Key? key}) : super(key: key);

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _expandedCategories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  List<Map<String, dynamic>> _favoriteDuas = [];

  // Mock data for duas categories
  final List<Map<String, dynamic>> _duasCategories = [
    {
      "id": 1,
      "name": "Morning Adhkar",
      "description": "Supplications to recite after Fajr prayer",
      "duas": [
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
          "id": 2,
          "title": "Subhan Allah wa bihamdihi",
          "arabic":
              "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ",
          "transliteration": "Subhan Allah wa bihamdihi, subhan Allah al-azeem",
          "translation":
              "Glory is to Allah and praise is to Him, glory is to Allah the Magnificent.",
          "category": "Morning Adhkar"
        },
        {
          "id": 3,
          "title": "La hawla wa la quwwata",
          "arabic": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
          "transliteration": "La hawla wa la quwwata illa billah",
          "translation": "There is no power and no strength except with Allah.",
          "category": "Morning Adhkar"
        }
      ]
    },
    {
      "id": 2,
      "name": "Evening Adhkar",
      "description": "Supplications to recite after Maghrib prayer",
      "duas": [
        {
          "id": 4,
          "title": "A'udhu billahi min ash-shaytani'r-rajim",
          "arabic": "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
          "transliteration": "A'udhu billahi min ash-shaytani'r-rajim",
          "translation": "I seek refuge in Allah from Satan, the accursed.",
          "category": "Evening Adhkar"
        },
        {
          "id": 5,
          "title": "Bismillahi'r-rahmani'r-rahim",
          "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
          "transliteration": "Bismillahi'r-rahmani'r-rahim",
          "translation":
              "In the name of Allah, the Most Gracious, the Most Merciful.",
          "category": "Evening Adhkar"
        }
      ]
    },
    {
      "id": 3,
      "name": "Daily Supplications",
      "description": "Essential duas for daily activities",
      "duas": [
        {
          "id": 6,
          "title": "Before eating",
          "arabic": "بِسْمِ اللَّهِ",
          "transliteration": "Bismillah",
          "translation": "In the name of Allah.",
          "category": "Daily Supplications"
        },
        {
          "id": 7,
          "title": "After eating",
          "arabic":
              "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
          "transliteration":
              "Alhamdu lillahi'lladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
          "translation":
              "Praise be to Allah who has fed me this and provided it for me without any effort or power on my part.",
          "category": "Daily Supplications"
        },
        {
          "id": 8,
          "title": "When leaving home",
          "arabic":
              "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
          "transliteration":
              "Bismillah, tawakkaltu 'ala Allah, wa la hawla wa la quwwata illa billah",
          "translation":
              "In the name of Allah, I trust in Allah, and there is no power and no strength except with Allah.",
          "category": "Daily Supplications"
        }
      ]
    },
    {
      "id": 4,
      "name": "Travel Duas",
      "description": "Supplications for safe journey",
      "duas": [
        {
          "id": 9,
          "title": "Dua for travel",
          "arabic":
              "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ",
          "transliteration":
              "Subhan alladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina la munqalibun",
          "translation":
              "Glory be to Him who has subjected this to us, and we could never have it by our efforts. Surely, to our Lord we shall return.",
          "category": "Travel Duas"
        },
        {
          "id": 10,
          "title": "Dua for safe arrival",
          "arabic":
              "الْحَمْدُ لِلَّهِ الَّذِي سَلَّمَنِي وَأَوَانِي وَجَمَعَ شَمْلِي",
          "transliteration":
              "Alhamdu lillahi'lladhi sallamani wa awani wa jama'a shamli",
          "translation":
              "Praise be to Allah who has brought me safely, given me shelter, and reunited me with my family.",
          "category": "Travel Duas"
        }
      ]
    },
    {
      "id": 5,
      "name": "Meal Duas",
      "description": "Supplications before and after meals",
      "duas": [
        {
          "id": 11,
          "title": "Before drinking water",
          "arabic": "بِسْمِ اللَّهِ",
          "transliteration": "Bismillah",
          "translation": "In the name of Allah.",
          "category": "Meal Duas"
        },
        {
          "id": 12,
          "title": "After drinking water",
          "arabic": "الْحَمْدُ لِلَّهِ",
          "transliteration": "Alhamdu lillah",
          "translation": "Praise be to Allah.",
          "category": "Meal Duas"
        },
        {
          "id": 13,
          "title": "When breaking fast",
          "arabic": "اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ",
          "transliteration": "Allahumma laka sumtu wa 'ala rizqika aftartu",
          "translation":
              "O Allah, for You I have fasted and with Your provision I have broken my fast.",
          "category": "Meal Duas"
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(_duasCategories);
    _loadFavoriteDuas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

        // If searching, expand categories that have matching duas
        _expandedCategories.clear();
        for (var category in _filteredCategories) {
          final duas = (category['duas'] as List);
          final hasMatchingDua = duas.any((dua) {
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

          if (hasMatchingDua) {
            _expandedCategories.add(category['name'] as String);
          }
        }
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredCategories = List.from(_duasCategories);
      _expandedCategories.clear();
    });
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      if (_expandedCategories.contains(categoryName)) {
        _expandedCategories.remove(categoryName);
      } else {
        _expandedCategories.add(categoryName);
      }
    });
  }

  Future<void> _refreshDuas() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _filteredCategories = List.from(_duasCategories);
      _loadFavoriteDuas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _clearSearch,
            ),

            // Main Content
            Expanded(
              child: _filteredCategories.isEmpty &&
                      _searchController.text.isNotEmpty
                  ? EmptySearchWidget(searchQuery: _searchController.text)
                  : RefreshIndicator(
                      onRefresh: _refreshDuas,
                      color: theme.colorScheme.primary,
                      child: CustomScrollView(
                        slivers: [
                          // Favorites Section
                          if (_favoriteDuas.isNotEmpty &&
                              _searchController.text.isEmpty)
                            SliverToBoxAdapter(
                              child:
                                  FavoritesSection(favoriteDuas: _favoriteDuas),
                            ),

                          // Categories List
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final category = _filteredCategories[index];
                                final categoryName = category['name'] as String;
                                final isExpanded =
                                    _expandedCategories.contains(categoryName);

                                return DuaCategoryCard(
                                  category: category,
                                  isExpanded: isExpanded,
                                  onTap: () => _toggleCategory(categoryName),
                                );
                              },
                              childCount: _filteredCategories.length,
                            ),
                          ),

                          // Bottom padding for navigation bar
                          SliverToBoxAdapter(
                            child: SizedBox(height: 12.h),
                          ),
                        ],
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
}
