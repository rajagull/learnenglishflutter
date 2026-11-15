import 'package:flutter/material.dart';
import '../../../../data/models/dictionary_model.dart';
import '../../../../data/models/idiom_model.dart';
import '../../../../data/repositories/conversation_repository.dart';
import '../../../../data/repositories/dictionary_repository.dart';
import '../../../../data/repositories/idiom_repository.dart';
import '../../../../data/repositories/singular_plural_repository.dart';
import '../../../../data/repositories/tense_repository.dart';
import '../../../../data/repositories/vocabulary_repository.dart';

enum DashboardCategoryFilter { all, grammar, reference, practice }

class DashboardStats {
  final int conversationCategories;
  final int conversationDialogues;
  final int vocabularyCategories;
  final int vocabularyItems;
  final int tensesCount;
  final int idiomsCount;
  final int singularPluralCount;
  final int dictionaryCount;

  const DashboardStats({
    this.conversationCategories = 22,
    this.conversationDialogues = 386,
    this.vocabularyCategories = 16,
    this.vocabularyItems = 324,
    this.tensesCount = 12,
    this.idiomsCount = 2000,
    this.singularPluralCount = 199,
    this.dictionaryCount = 141054,
  });
}

class DashboardViewModel extends ChangeNotifier {
  final ConversationRepository _conversationRepo;
  final VocabularyRepository _vocabularyRepo;
  final TenseRepository _tenseRepo;
  final IdiomRepository _idiomRepo;
  final SingularPluralRepository _singularPluralRepo;
  final DictionaryRepository _dictionaryRepo;

  DashboardViewModel({
    ConversationRepository? conversationRepo,
    VocabularyRepository? vocabularyRepo,
    TenseRepository? tenseRepo,
    IdiomRepository? idiomRepo,
    SingularPluralRepository? singularPluralRepo,
    DictionaryRepository? dictionaryRepo,
  })  : _conversationRepo = conversationRepo ?? ConversationRepository(),
        _vocabularyRepo = vocabularyRepo ?? VocabularyRepository(),
        _tenseRepo = tenseRepo ?? TenseRepository(),
        _idiomRepo = idiomRepo ?? IdiomRepository(),
        _singularPluralRepo = singularPluralRepo ?? SingularPluralRepository(),
        _dictionaryRepo = dictionaryRepo ?? DictionaryRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DashboardStats _stats = const DashboardStats();
  DashboardStats get stats => _stats;

  IdiomItem? _dailyIdiom;
  IdiomItem? get dailyIdiom => _dailyIdiom;

  DictionaryWord? _dailyWord;
  DictionaryWord? get dailyWord => _dailyWord;

  DashboardCategoryFilter _selectedFilter = DashboardCategoryFilter.all;
  DashboardCategoryFilter get selectedFilter => _selectedFilter;

  void setFilter(DashboardCategoryFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _conversationRepo.getCategoriesCount().catchError((_) => 22),
        _conversationRepo.getTotalDialoguesCount().catchError((_) => 386),
        _vocabularyRepo.getCategoriesCount().catchError((_) => 16),
        _vocabularyRepo.getTotalWordsCount().catchError((_) => 324),
        _tenseRepo.getTotalTensesCount().catchError((_) => 12),
        _idiomRepo.getTotalCount().catchError((_) => 2000),
        _singularPluralRepo.getTotalCount().catchError((_) => 199),
        _idiomRepo.getRandomIdiom().catchError((_) => null),
      ]);

      _stats = DashboardStats(
        conversationCategories: results[0] as int,
        conversationDialogues: results[1] as int,
        vocabularyCategories: results[2] as int,
        vocabularyItems: results[3] as int,
        tensesCount: results[4] as int,
        idiomsCount: results[5] as int,
        singularPluralCount: results[6] as int,
        dictionaryCount: 141054,
      );

      _dailyIdiom = results[7] as IdiomItem?;

      // Load daily word asynchronously without blocking UI
      _loadDailyWord();
    } catch (e) {
      debugPrint('[DashboardViewModel] Error loading stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDailyWord() async {
    try {
      _dailyWord = await _dictionaryRepo.getRandomWord();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> refreshDailyFeatured() async {
    try {
      final idiom = await _idiomRepo.getRandomIdiom();
      final word = await _dictionaryRepo.getRandomWord();
      if (idiom != null) _dailyIdiom = idiom;
      if (word != null) _dailyWord = word;
      notifyListeners();
    } catch (_) {}
  }
}
