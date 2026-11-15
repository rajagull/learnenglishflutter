import 'package:flutter/material.dart';
import '../../../../data/models/singular_plural_model.dart';
import '../../../../data/repositories/singular_plural_repository.dart';

class SingularPluralViewModel extends ChangeNotifier {
  final SingularPluralRepository _repository;

  SingularPluralViewModel({SingularPluralRepository? repository})
      : _repository = repository ?? SingularPluralRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SingularPluralItem> _items = [];
  List<SingularPluralItem> get items => _items;

  String _searchQuery = '';

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _repository.getAll(query: _searchQuery);
    } catch (e) {
      debugPrint('[SingularPluralViewModel] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    loadItems();
  }
}
