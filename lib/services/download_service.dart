import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DownloadService {
  Future<String> downloadCardImage(String imageUrl, String cardId, String cardName) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        // Get the app directory (same directory as executable)
        final appDir = Directory.current.path;
        
        // Sanitize the card name for filename
        final sanitizedName = cardName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
        final fileName = '${cardId}_$sanitizedName.png';
        final filePath = path.join(appDir, fileName);
        
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

  Future<bool> imageExists(String cardId, String cardName) async {
    try {
      final appDir = Directory.current.path;
      final sanitizedName = cardName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final fileName = '${cardId}_$sanitizedName.png';
      final filePath = path.join(appDir, fileName);
      
      return File(filePath).existsSync();
    } catch (e) {
      return false;
    }
  }
}

