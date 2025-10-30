import 'package:flutter/material.dart';
import '../models/pokemon_card.dart';
import '../models/pokemon_set.dart';
import '../services/api_service.dart';
import '../widgets/search_bar.dart';
import '../widgets/card_tile.dart';
import 'card_detail_screen.dart';

class CardsScreen extends StatefulWidget {
  final PokemonSet set;

  const CardsScreen({
    super.key,
    required this.set,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final ApiService _apiService = ApiService();
  List<PokemonCard> _cards = [];
  List<PokemonCard> _filteredCards = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cards = await _apiService.getCardsBySet(widget.set.id);
      setState(() {
        _cards = cards;
        _filteredCards = cards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load cards: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCards = _cards;
      } else {
        _filteredCards = _cards
            .where((card) =>
                card.name.toLowerCase().contains(query.toLowerCase()) ||
                (card.number != null &&
                    card.number!.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _searchQuery = '';
      _filteredCards = _cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.set.name),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadCards,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: Column(
        children: [
          SearchBar(
            hintText: 'Search cards...',
            onSearchChanged: _onSearchChanged,
            onClear: _onSearchCleared,
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCards,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No cards found'
                  : 'No cards match "$_searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredCards.length,
      itemBuilder: (context, index) {
        final card = _filteredCards[index];
        return CardTile(
          card: card,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardDetailScreen(card: card),
              ),
            );
          },
        );
      },
    );
  }
}

