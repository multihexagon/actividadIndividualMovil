import 'package:flutter/material.dart';
import 'package:myapp/screens/pokemon_detail_screen.dart';
import 'package:myapp/services/pokeapi_service.dart';

class PokemonListScreen extends StatefulWidget {
  final String category;

  PokemonListScreen({required this.category});

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<String> pokemons = [];

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  Future<void> fetchPokemons() async {
    final pokemonList = await PokeApiService.fetchPokemonsByCategory(widget.category);
    setState(() {
      pokemons = pokemonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokémon de tipo ${widget.category.toUpperCase()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.redAccent,  // Pokedex red color for the app bar
        elevation: 5,  // Shadow effect
      ),
      body: Container(
        color: Colors.red[50],  // Light red background for the screen
        padding: EdgeInsets.all(12.0),  // Add padding for a clean layout
        child: pokemons.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  return PokedexPokemonCard(
                    pokemonName: pokemons[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PokemonDetailScreen(pokemonName: pokemons[index]),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class PokedexPokemonCard extends StatelessWidget {
  final String pokemonName;
  final VoidCallback onTap;

  PokedexPokemonCard({required this.pokemonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),  // Rounded corners
        side: BorderSide(color: Colors.black, width: 2),  // Black border like Pokedex
      ),
      color: Colors.yellow[300],  // Pokedex button yellow color
      elevation: 5,  // Elevation for card shadow
      margin: EdgeInsets.symmetric(vertical: 8.0),  // Vertical margin between cards
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),  // Add padding inside the tile
        title: Text(
          pokemonName.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,  // Spaced text
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.black),  // Forward icon
        onTap: onTap,
      ),
    );
  }
}
