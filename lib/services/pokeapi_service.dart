import 'package:http/http.dart' as http;
import 'dart:convert';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // Fetch categories (types of Pokémon)
  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((type) => type['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch Pokémon by category (type)
  static Future<List<String>> fetchPokemonsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/type/$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['pokemon'] as List).map((pokemon) => pokemon['pokemon']['name'].toString()).toList();
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  // Fetch Pokémon details by name
  static Future<Map<String, dynamic>> fetchPokemonDetails(String pokemonName) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonName'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pokemon details');
    }
  }
}
