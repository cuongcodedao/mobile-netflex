import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/film/category.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/item_search.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/category_repository.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

enum SearchMode { text, category }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FilmRepository filmRepository;
  late final CategoryRepository categoryRepository;

  final TextEditingController textEditingController = TextEditingController();
  List<Film> _displayedFilms = [];
  bool _isLoading = false;
  Timer? _debounce;

  SearchMode _currentSearchMode = SearchMode.text;
  List<Category> _allCategories = [];
  Category? _selectedCategory;
  bool _isLoadingCategories = true;

  final String imageBaseUrl = "https://phimimg.com/"; // Assuming this is your image base URL

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(); // Consider injecting ApiService
    filmRepository = FilmRepository(apiService);
    categoryRepository = CategoryRepository(apiService);
    _loadInitialCategories();

    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty && _currentSearchMode == SearchMode.category) {
        setState(() {
          _currentSearchMode = SearchMode.text;
          _selectedCategory = null;
          _displayedFilms = [];
        });
      }
      if (_currentSearchMode == SearchMode.text) {
        _onSearchTextChanged();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      _allCategories = await categoryRepository.getAllCategory();
    } catch (e) {
      print("Error loading initial categories: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading categories: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  void _onSearchTextChanged() {
    if (_currentSearchMode != SearchMode.text) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (textEditingController.text.trim().isEmpty) {
        if (!mounted) return;
        setState(() {
          _displayedFilms = [];
          _isLoading = false;
        });
        return;
      }
      _fetchFilmsByTextSearch();
    });
  }

  Future<void> _fetchFilmsByTextSearch() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      List<Film> filmsTmp = await filmRepository.getSearchFilm(
        textEditingController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _displayedFilms = filmsTmp;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _displayedFilms = [];
      });
      debugPrint('Error loading search film page: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchFilmsByCategory(Category category) async {
    if (!mounted) return;
    setState(() {
      _currentSearchMode = SearchMode.category;
      _selectedCategory = category;
      textEditingController.clear();
      _isLoading = true;
      _displayedFilms = [];
    });
    try {
      if (category.slug == null) {
        throw Exception("Category slug is null");
      }
      List<Film> filmsTmp = await filmRepository.getFilmByGenre(category.slug!);
      if (!mounted) return;
      setState(() {
        _displayedFilms = filmsTmp;
      });
    } catch (e) {
      print('Error loading films for category ${category.name}: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading films for ${category.name ?? 'category'}: ${e.toString()}")),
        );
      }
      if (!mounted) return;
      setState(() {
        _displayedFilms = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80, height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: double.infinity, height: 20.0, color: Colors.white, margin: const EdgeInsets.only(bottom: 8.0)),
                    Container(width: MediaQuery.of(context).size.width * 0.5, height: 16.0, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Or your desired background color
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0), // Added top padding
        child: Column(
          children: [
            // --- Text Search Input ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: "Search for films...", // English
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Category Selection Dropdown ---
            if (_isLoadingCategories)
              const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.redAccent)))
            else if (_allCategories.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Category?>(
                    value: _selectedCategory,
                    hint: const Text("Or select by category...", style: TextStyle(color: Colors.white70)), // English
                    isExpanded: true,
                    dropdownColor: Colors.grey[850],
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: [
                      const DropdownMenuItem<Category?>(
                        value: null,
                        child: Text("--- Clear category selection ---", style: TextStyle(color: Colors.white54)), // English
                      ),
                      ..._allCategories.map((Category category) {
                        return DropdownMenuItem<Category?>(
                          value: category,
                          child: Text(category.name ?? 'N/A'),
                        );
                      }).toList(),
                    ],
                    onChanged: (Category? newValue) {
                      if (newValue != null) {
                        _fetchFilmsByCategory(newValue);
                      } else {
                        setState(() {
                          _currentSearchMode = SearchMode.text;
                          _selectedCategory = null;
                          _displayedFilms = [];
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // --- Results Display ---
            Expanded(
              child: _buildResultsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsWidget() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    if (_currentSearchMode == SearchMode.text) {
      if (_displayedFilms.isEmpty && textEditingController.text.isNotEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text("No results found.", style: TextStyle(color: Colors.white60, fontSize: 18)), // English
        );
      } else if (_displayedFilms.isEmpty && textEditingController.text.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text("Type a film name or select a category to search.", style: TextStyle(color: Colors.white60, fontSize: 16), textAlign: TextAlign.center), // English
        );
      }
    } else if (_currentSearchMode == SearchMode.category) {
      if (_selectedCategory == null) {
         return const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text("Please select a category.", style: TextStyle(color: Colors.white60, fontSize: 16), textAlign: TextAlign.center), // English
        );
      }
      if (_displayedFilms.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text("No films found for '${_selectedCategory!.name ?? 'this category'}'.", style: TextStyle(color: Colors.white60, fontSize: 16), textAlign: TextAlign.center), // English
        );
      }
    }

    if (_displayedFilms.isEmpty) {
         return const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text("Type a film name or select a category to search.", style: TextStyle(color: Colors.white60, fontSize: 16), textAlign: TextAlign.center), // English
        );
    }

    return ListView.builder(
      itemCount: _displayedFilms.length,
      itemBuilder: (context, index) {
        final film = _displayedFilms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ItemSearch(
            urlPoster: "$imageBaseUrl${film.urlPoster}",
            name: film.name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WatchingScreen(slug: film.slug)),
              );
            },
          ),
        );
      },
    );
  }
}