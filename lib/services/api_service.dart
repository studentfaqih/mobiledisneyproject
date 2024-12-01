// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://www.omdbapi.com/';
  static const String apiKey = 'e8be4267';

  Future<Map<String, dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl?apikey=$apiKey&s=$query&type=movie'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(String imdbId) async {
    final response = await http.get(
      Uri.parse('$baseUrl?apikey=$apiKey&i=$imdbId&plot=full'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
