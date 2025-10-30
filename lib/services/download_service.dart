import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DownloadService {
  String get _appDirectory {
    // Get the directory where the executable is located
    final executablePath = Platform.resolvedExecutable;
    final executableDir = path.dirname(executablePath);
    return executableDir;
  }

  String _sanitizeFolderName(String name) {
    // Remove invalid characters for folder names
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
  }

  String _sanitizeFileName(String name) {
    // Remove invalid characters for file names
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  Future<String> downloadCardImage(
    String imageUrl,
    String cardId,
    String cardName,
    String setName,
  ) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        // Use the executable's directory
        final appDir = _appDirectory;
        
        // Create downloads folder
        final downloadsDir = path.join(appDir, 'downloads');
        final downloadsFolder = Directory(downloadsDir);
        if (!downloadsFolder.existsSync()) {
          downloadsFolder.createSync(recursive: true);
        }
        
        // Create set folder
        final sanitizedSetName = _sanitizeFolderName(setName);
        final setDir = path.join(downloadsDir, sanitizedSetName);
        final setFolder = Directory(setDir);
        if (!setFolder.existsSync()) {
          setFolder.createSync(recursive: true);
        }
        
        // Sanitize the card name for filename
        final sanitizedName = _sanitizeFileName(cardName);
        final fileName = '${cardId}_$sanitizedName.png';
        final filePath = path.join(setDir, fileName);
        
        // Write the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        return filePath;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }

  Future<bool> imageExists(String cardId, String cardName, String setName) async {
    try {
      final appDir = _appDirectory;
      final downloadsDir = path.join(appDir, 'downloads');
      final sanitizedSetName = _sanitizeFolderName(setName);
      final setDir = path.join(downloadsDir, sanitizedSetName);
      final sanitizedName = _sanitizeFileName(cardName);
      final fileName = '${cardId}_$sanitizedName.png';
      final filePath = path.join(setDir, fileName);
      
      return File(filePath).existsSync();
    } catch (e) {
      return false;
    }
  }
}

