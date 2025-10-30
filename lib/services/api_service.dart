import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_set.dart';
import '../models/pokemon_card.dart';

class ApiService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';
  static const String apiKey = '90a77dc2-3ec9-4d62-abf7-7da1da854c37';

  Map<String, String> get _headers => {
        'X-Api-Key': apiKey,
        'Content-Type': 'application/json',
      };

  Future<List<PokemonSet>> getSets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sets'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> setsData = data['data'] ?? [];
        return setsData.map((json) => PokemonSet.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sets: $e');
    }
  }

  Future<List<PokemonCard>> getCardsBySet(String setId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards?q=set.id:$setId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cardsData = data['data'] ?? [];
        return cardsData.map((json) => PokemonCard.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<List<PokemonCard>> searchCards(String query) async {
    try {
      // Escape query for URL
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('$baseUrl/cards?q=$encodedQuery'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cardsData = data['data'] ?? [];
        return cardsData.map((json) => PokemonCard.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search cards: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching cards: $e');
    }
  }

  Future<List<PokemonSet>> searchSets(String query) async {
    try {
      // Escape query for URL
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('$baseUrl/sets?q=$encodedQuery'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> setsData = data['data'] ?? [];
        return setsData.map((json) => PokemonSet.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching sets: $e');
    }
  }

  Future<PokemonCard?> getCardById(String cardId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards/$cardId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PokemonCard.fromJson(data['data']);
      } else {
        throw Exception('Failed to load card: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching card: $e');
    }
  }
}

