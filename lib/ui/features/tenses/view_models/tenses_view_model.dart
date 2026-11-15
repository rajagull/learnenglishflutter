import 'package:flutter/material.dart';
import '../../../../data/models/tense_model.dart';
import '../../../../data/repositories/tense_repository.dart';

class TensesViewModel extends ChangeNotifier {
  final TenseRepository _repository;

  TensesViewModel({TenseRepository? repository})
      : _repository = repository ?? TenseRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TenseMain> _mainTenses = [];
  List<TenseMain> get mainTenses => _mainTenses;

  List<TenseCategory> _categories = [];
  List<TenseCategory> get categories => _categories;

  int? _selectedTenseId;
  int? get selectedTenseId => _selectedTenseId;

  List<TenseExample> _examples = [];
  List<TenseExample> get examples => _examples;

  Future<void> loadTenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _mainTenses = await _repository.getMainTenses();
      _categories = await _repository.getCategories();
    } catch (e) {
      debugPrint('[TensesViewModel] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByMainTense(int? tenseId) {
    _selectedTenseId = tenseId;
    notifyListeners();
  }

  List<TenseCategory> get visibleCategories {
    if (_selectedTenseId == null) return _categories;
    return _categories.where((c) => c.tenseId == _selectedTenseId).toList();
  }

  Future<void> loadExamples(int categoryId) async {
    _isLoading = true;
    _examples = [];
    notifyListeners();

    try {
      _examples = await _repository.getExamples(categoryId);
    } catch (e) {
      debugPrint('[TensesViewModel] Error loading examples: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
