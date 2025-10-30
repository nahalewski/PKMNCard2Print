import 'package:flutter/material.dart';
import '../models/pokemon_set.dart';
import '../services/api_service.dart';
import '../widgets/search_bar.dart';
import '../widgets/set_card.dart';
import 'cards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<PokemonSet> _sets = [];
  List<PokemonSet> _filteredSets = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSets();
  }

  Future<void> _loadSets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sets = await _apiService.getSets();
      setState(() {
        _sets = sets;
        _filteredSets = sets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sets: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSets = _sets;
      } else {
        _filteredSets = _sets
            .where((set) =>
                set.name.toLowerCase().contains(query.toLowerCase()) ||
                set.series.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSearchCleared() {
    setState(() {
      _searchQuery = '';
      _filteredSets = _sets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Card Sets'),
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
              onPressed: _loadSets,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: Column(
        children: [
          SearchBar(
            hintText: 'Search sets...',
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
              onPressed: _loadSets,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredSets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No sets found'
                  : 'No sets match "$_searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredSets.length,
      itemBuilder: (context, index) {
        final set = _filteredSets[index];
        return SetCard(
          set: set,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardsScreen(set: set),
              ),
            );
          },
        );
      },
    );
  }
}

