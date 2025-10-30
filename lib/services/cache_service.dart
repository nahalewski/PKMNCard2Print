import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon_set.dart';
import '../models/pokemon_card.dart';

class CacheService {
  static const String _setsCacheKey = 'cached_sets';
  static const String _setsCacheTimestampKey = 'cached_sets_timestamp';
  static const String _cardsCachePrefix = 'cached_cards_';
  static const String _cardsCacheTimestampPrefix = 'cached_cards_timestamp_';
  static const String _searchHistoryKey = 'search_history';
  static const Duration _cacheExpiry = Duration(hours: 24);

  // Cache sets
  Future<void> cacheSets(List<PokemonSet> sets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = sets.map((set) => set.toJson()).toList();
      await prefs.setString(_setsCacheKey, json.encode(jsonList));
      await prefs.setInt(_setsCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching sets: $e');
    }
  }

  // Get cached sets
  Future<List<PokemonSet>?> getCachedSets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_setsCacheTimestampKey);
      
      if (timestamp == null) return null;
      
      final cacheAge = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      
      if (cacheAge > _cacheExpiry) {
        return null; // Cache expired
      }
      
      final jsonString = prefs.getString(_setsCacheKey);
      if (jsonString == null) return null;
      
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => PokemonSet.fromJson(json)).toList();
    } catch (e) {
      print('Error getting cached sets: $e');
      return null;
    }
  }

  // Cache cards for a set
  Future<void> cacheCardsForSet(String setId, List<PokemonCard> cards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = cards.map((card) => card.toJson()).toList();
      await prefs.setString('$_cardsCachePrefix$setId', json.encode(jsonList));
      await prefs.setInt('$_cardsCacheTimestampPrefix$setId', 
          DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching cards: $e');
    }
  }

  // Get cached cards for a set
  Future<List<PokemonCard>?> getCachedCardsForSet(String setId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('$_cardsCacheTimestampPrefix$setId');
      
      if (timestamp == null) return null;
      
      final cacheAge = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      
      if (cacheAge > _cacheExpiry) {
        return null; // Cache expired
      }
      
      final jsonString = prefs.getString('$_cardsCachePrefix$setId');
      if (jsonString == null) return null;
      
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => PokemonCard.fromJson(json)).toList();
    } catch (e) {
      print('Error getting cached cards: $e');
      return null;
    }
  }

  // Add search to history
  Future<void> addSearchHistory(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_searchHistoryKey) ?? [];
      if (!history.contains(query.toLowerCase())) {
        history.insert(0, query.toLowerCase());
        // Keep only last 50 searches
        if (history.length > 50) {
          history.removeRange(50, history.length);
        }
        await prefs.setStringList(_searchHistoryKey, history);
      }
    } catch (e) {
      print('Error adding search history: $e');
    }
  }

  // Get search history
  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  // Clear all cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cardsCachePrefix) || 
            key.startsWith(_cardsCacheTimestampPrefix) ||
            key == _setsCacheKey ||
            key == _setsCacheTimestampKey) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}

