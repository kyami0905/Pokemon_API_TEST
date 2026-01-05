import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('リクエストに失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('エラーが発生しました: $e');
    }
  }
}

