import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/pokemon_set.dart';
import '../models/pokemon_card.dart';
import 'cache_service.dart';

class ApiService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';
  static const String apiKey = '90a77dc2-3ec9-4d62-abf7-7da1da854c37';
  final CacheService _cacheService = CacheService();
  CacheService get cacheService => _cacheService; // Expose cache service
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  Map<String, String> get _headers => {
        'X-Api-Key': apiKey,
        'Content-Type': 'application/json',
      };

  Future<http.Response> _getWithRetry(String url) async {
    int retries = 0;
    while (retries < _maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: _headers,
        ).timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode == 504 && retries < _maxRetries - 1) {
          // Gateway timeout - retry
          retries++;
          await Future.delayed(_retryDelay * retries);
          continue;
        } else {
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        if (retries < _maxRetries - 1 && e.toString().contains('TimeoutException')) {
          retries++;
          await Future.delayed(_retryDelay * retries);
          continue;
        }
        if (retries < _maxRetries - 1) {
          retries++;
          await Future.delayed(_retryDelay * retries);
          continue;
        }
        rethrow;
      }
    }
    throw Exception('Max retries reached');
  }

  Future<List<PokemonSet>> getSets({bool forceRefresh = false}) async {
    // Check cache first unless forcing refresh
    if (!forceRefresh) {
      final cachedSets = await _cacheService.getCachedSets();
      if (cachedSets != null && cachedSets.isNotEmpty) {
        return cachedSets;
      }
    }

    // Always try API for fresh data
    try {
      final response = await _getWithRetry('$baseUrl/sets');
      final data = json.decode(response.body);
      final List<dynamic> setsData = data['data'] ?? [];
      final sets = setsData.map((json) => PokemonSet.fromJson(json)).toList();
      
      // Cache the results
      await _cacheService.cacheSets(sets);
      
      return sets;
    } catch (e) {
      // If request fails, try to return cached data as fallback
      if (!forceRefresh) {
        final cachedSets = await _cacheService.getCachedSets();
        if (cachedSets != null && cachedSets.isNotEmpty) {
          return cachedSets;
        }
      }
      throw Exception('Error fetching sets: $e');
    }
  }

  Future<void> _refreshSetsInBackground() async {
    try {
      final response = await _getWithRetry('$baseUrl/sets');
      final data = json.decode(response.body);
      final List<dynamic> setsData = data['data'] ?? [];
      final sets = setsData.map((json) => PokemonSet.fromJson(json)).toList();
      await _cacheService.cacheSets(sets);
    } catch (e) {
      // Silent fail for background refresh
      print('Background refresh failed: $e');
    }
  }

  Future<List<PokemonCard>> getCardsBySet(String setId, {bool forceRefresh = false}) async {
    // Check cache first unless forcing refresh
    if (!forceRefresh) {
      final cachedCards = await _cacheService.getCachedCardsForSet(setId);
      if (cachedCards != null && cachedCards.isNotEmpty) {
        return cachedCards;
      }
    }

    // Always try API for fresh data
    try {
      final response = await _getWithRetry('$baseUrl/cards?q=set.id:$setId');
      final data = json.decode(response.body);
      final List<dynamic> cardsData = data['data'] ?? [];
      final cards = cardsData.map((json) => PokemonCard.fromJson(json)).toList();
      
      // Cache the results
      await _cacheService.cacheCardsForSet(setId, cards);
      
      return cards;
    } catch (e) {
      // If request fails, try to return cached data as fallback
      if (!forceRefresh) {
        final cachedCards = await _cacheService.getCachedCardsForSet(setId);
        if (cachedCards != null && cachedCards.isNotEmpty) {
          return cachedCards;
        }
      }
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<List<PokemonCard>> searchCards(String query) async {
    // Add to search history
    if (query.isNotEmpty) {
      await _cacheService.addSearchHistory(query);
    }

    try {
      // Escape query for URL
      final encodedQuery = Uri.encodeComponent(query);
      final response = await _getWithRetry('$baseUrl/cards?q=$encodedQuery');
      final data = json.decode(response.body);
      final List<dynamic> cardsData = data['data'] ?? [];
      return cardsData.map((json) => PokemonCard.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error searching cards: $e');
    }
  }

  Future<List<PokemonSet>> searchSets(String query) async {
    // Add to search history
    if (query.isNotEmpty) {
      await _cacheService.addSearchHistory(query);
    }

    try {
      // Escape query for URL - search by name
      final encodedQuery = Uri.encodeComponent('name:$query');
      final response = await _getWithRetry('$baseUrl/sets?q=$encodedQuery');
      final data = json.decode(response.body);
      final List<dynamic> setsData = data['data'] ?? [];
      return setsData.map((json) => PokemonSet.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error searching sets: $e');
    }
  }

  Future<PokemonCard?> getCardById(String cardId) async {
    try {
      final response = await _getWithRetry('$baseUrl/cards/$cardId');
      final data = json.decode(response.body);
      return PokemonCard.fromJson(data['data']);
    } catch (e) {
      throw Exception('Error fetching card: $e');
    }
  }
}

