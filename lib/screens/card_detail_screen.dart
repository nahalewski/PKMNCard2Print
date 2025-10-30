import 'package:flutter/material.dart';
import '../models/pokemon_card.dart';
import '../services/download_service.dart';

class CardDetailScreen extends StatefulWidget {
  final PokemonCard card;

  const CardDetailScreen({
    super.key,
    required this.card,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final DownloadService _downloadService = DownloadService();
  bool _isDownloading = false;
  String? _downloadMessage;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfDownloaded();
  }

  Future<void> _checkIfDownloaded() async {
    final exists = await _downloadService.imageExists(
      widget.card.id,
      widget.card.name,
    );
    setState(() {
      _isDownloaded = exists;
    });
  }

  Future<void> _downloadImage() async {
    if (widget.card.images?.large == null) {
      setState(() {
        _downloadMessage = 'No high-resolution image available';
      });
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadMessage = null;
    });

    try {
      final filePath = await _downloadService.downloadCardImage(
        widget.card.images!.large!,
        widget.card.id,
        widget.card.name,
      );

      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
        _downloadMessage = 'Downloaded to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _downloadMessage = 'Download failed: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Card Image
            Container(
              constraints: const BoxConstraints(maxHeight: 600),
              child: widget.card.images?.large != null
                  ? Image.network(
                      widget.card.images!.large!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64),
                              SizedBox(height: 8),
                              Text('Failed to load image'),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 64),
                          SizedBox(height: 8),
                          Text('No image available'),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // Download Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isDownloading ? null : _downloadImage,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isDownloaded ? Icons.check_circle : Icons.download),
                label: Text(_isDownloading
                    ? 'Downloading...'
                    : _isDownloaded
                        ? 'Already Downloaded'
                        : 'Download High-Resolution Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isDownloaded ? Colors.green : null,
                ),
              ),
            ),
            if (_downloadMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _downloadMessage!,
                style: TextStyle(
                  color: _downloadMessage!.contains('failed')
                      ? Colors.red
                      : Colors.green,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            // Card Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Name', widget.card.name),
                    if (widget.card.number != null)
                      _buildDetailRow('Number', widget.card.number!),
                    if (widget.card.supertype != null)
                      _buildDetailRow('Type', widget.card.supertype!),
                    if (widget.card.rarity != null)
                      _buildDetailRow('Rarity', widget.card.rarity!),
                    if (widget.card.set != null) ...[
                      _buildDetailRow('Set', widget.card.set!.name),
                      _buildDetailRow('Series', widget.card.set!.series),
                    ],
                    if (widget.card.hp != null)
                      _buildDetailRow('HP', widget.card.hp!),
                    if (widget.card.artist != null)
                      _buildDetailRow('Artist', widget.card.artist!),
                    if (widget.card.flavorText != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Flavor Text',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.card.flavorText!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

