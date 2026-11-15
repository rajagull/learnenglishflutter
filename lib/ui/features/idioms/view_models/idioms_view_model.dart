import 'package:flutter/material.dart';
import '../../../../data/models/idiom_model.dart';
import '../../../../data/repositories/idiom_repository.dart';

class IdiomsViewModel extends ChangeNotifier {
  final IdiomRepository _repository;

  IdiomsViewModel({IdiomRepository? repository})
      : _repository = repository ?? IdiomRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  List<IdiomItem> _idioms = [];
  List<IdiomItem> get idioms => _idioms;

  String _searchQuery = '';
  int _offset = 0;
  static const int _limit = 50;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> loadIdioms({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final items = await _repository.getIdioms(
        query: _searchQuery,
        limit: _limit,
        offset: _offset,
      );

      if (refresh || _offset == 0) {
        _idioms = items;
      } else {
        _idioms.addAll(items);
      }

      if (items.length < _limit) {
        _hasMore = false;
      }
      _offset += items.length;
    } catch (e) {
      debugPrint('[IdiomsViewModel] Error: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.trim();
    loadIdioms(refresh: true);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();
    await loadIdioms(refresh: false);
  }
}
