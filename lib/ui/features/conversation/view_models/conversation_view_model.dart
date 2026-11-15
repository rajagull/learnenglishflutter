import 'package:flutter/material.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../../data/repositories/conversation_repository.dart';

class ConversationViewModel extends ChangeNotifier {
  final ConversationRepository _repository;

  ConversationViewModel({ConversationRepository? repository})
      : _repository = repository ?? ConversationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ConversationCategory> _categories = [];
  List<ConversationCategory> get categories => _categories;

  List<ConversationCategory> _filteredCategories = [];
  List<ConversationCategory> get filteredCategories => _filteredCategories;

  List<ConversationDetail> _currentDetails = [];
  List<ConversationDetail> get currentDetails => _currentDetails;

  String _searchQuery = '';

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _filterCategories();
    } catch (e) {
      debugPrint('[ConversationViewModel] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
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

  Future<void> loadDetails(int categoryId) async {
    _isLoading = true;
    _currentDetails = [];
    notifyListeners();

    try {
      _currentDetails = await _repository.getDetails(categoryId);
    } catch (e) {
      debugPrint('[ConversationViewModel] Error loading details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
