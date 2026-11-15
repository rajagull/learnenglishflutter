import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../data/models/dictionary_model.dart';
import '../../../../data/repositories/dictionary_repository.dart';

class DictionaryViewModel extends ChangeNotifier {
  final DictionaryRepository _repository;

  DictionaryViewModel({DictionaryRepository? repository})
      : _repository = repository ?? DictionaryRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DictionaryWord> _words = [];
  List<DictionaryWord> get words => _words;

  Timer? _debounce;
  String _currentQuery = '';

  Future<void> loadInitialWords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _words = await _repository.getRecentOrPopularWords(limit: 25);
    } catch (e) {
      debugPrint('[DictionaryViewModel] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _currentQuery = query;

    if (query.trim().isEmpty) {
      loadInitialWords();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _executeSearch(_currentQuery);
    });
  }

  Future<void> _executeSearch(String query) async {
    if (query.trim().isEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      _words = await _repository.searchWords(query.trim(), limit: 40);
    } catch (e) {
      debugPrint('[DictionaryViewModel] Search error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
