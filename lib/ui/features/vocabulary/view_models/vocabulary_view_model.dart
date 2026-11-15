import 'package:flutter/material.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../../data/repositories/vocabulary_repository.dart';

class VocabularyViewModel extends ChangeNotifier {
  final VocabularyRepository _repository;

  VocabularyViewModel({VocabularyRepository? repository})
      : _repository = repository ?? VocabularyRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VocabularyCategory> _categories = [];
  List<VocabularyCategory> get categories => _categories;

  List<VocabularyCategory> _filteredCategories = [];
  List<VocabularyCategory> get filteredCategories => _filteredCategories;

  List<VocabularyItem> _currentItems = [];
  List<VocabularyItem> get currentItems => _currentItems;

  List<VocabularyItem> _filteredItems = [];
  List<VocabularyItem> get filteredItems => _filteredItems;

  String _searchQuery = '';
  String _itemSearchQuery = '';

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _filterCategories();
    } catch (e) {
      debugPrint('[VocabularyViewModel] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCategories(String query) {
    _searchQuery = query.trim().toLowerCase();
    _filterCategories();
    notifyListeners();
  }

  void _filterCategories() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = List.from(_categories);
    } else {
      _filteredCategories = _categories.where((cat) {
        return cat.englishName.toLowerCase().contains(_searchQuery) ||
            cat.urduName.contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> loadItems(int categoryId) async {
    _isLoading = true;
    _currentItems = [];
    _filteredItems = [];
    notifyListeners();

    try {
      _currentItems = await _repository.getItems(categoryId);
      _filterItems();
    } catch (e) {
      debugPrint('[VocabularyViewModel] Error loading items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchItems(String query) {
    _itemSearchQuery = query.trim().toLowerCase();
    _filterItems();
    notifyListeners();
  }

  void _filterItems() {
    if (_itemSearchQuery.isEmpty) {
      _filteredItems = List.from(_currentItems);
    } else {
      _filteredItems = _currentItems.where((item) {
        return item.english.toLowerCase().contains(_itemSearchQuery) ||
            item.urdu.contains(_itemSearchQuery) ||
            item.roman.toLowerCase().contains(_itemSearchQuery);
      }).toList();
    }
  }
}
