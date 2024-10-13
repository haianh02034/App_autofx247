import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Use secure storage
import 'dart:io';

class ApiMessagesService {
  final _storage = FlutterSecureStorage(); // Initialize secure storage

  Future<List<dynamic>> fetchTelegramMessages() async {
    var url = '${dotenv.env['API_URL']}/api/telegramMessage'; // Load API URL from .env
    String? accessToken = await _storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
        'Authorization': 'Bearer $accessToken',
        },
      );
    print('Authorization: Bearer $accessToken'); // Log to see the token

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Return the items from the response
      return data['paginate']['items']; // Extract items from paginate
      } else {
        print('Failed to load messages: ${response.statusCode}');
        return []; // Return an empty list on error
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return []; // Return an empty list on exception
    }
  }
}
