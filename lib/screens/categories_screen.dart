import 'package:flutter/material.dart';
import 'package:myapp/screens/pokemon_list_screen.dart';
import 'package:myapp/services/pokeapi_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final categoriesData = await PokeApiService.fetchCategories();
    setState(() {
      categories = categoriesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categorías de Pokémon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.redAccent,  // Pokedex red
        elevation: 5,
      ),
      body: Container(
        color: Colors.red[50],  // Light red background
        padding: EdgeInsets.all(12.0),  // Padding for better layout
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return PokedexCategoryCard(
                    categoryName: categories[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PokemonListScreen(category: categories[index]),
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

class PokedexCategoryCard extends StatelessWidget {
  final String categoryName;
  final VoidCallback onTap;

  PokedexCategoryCard({required this.categoryName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),  // Rounded corners
        side: BorderSide(color: Colors.black, width: 2),  // Black border like Pokedex design
      ),
      color: Colors.yellow[300],  // Pokedex yellow
      elevation: 5,  // Elevation for shadow
      margin: EdgeInsets.symmetric(vertical: 8.0),  // Space between cards
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),  // Padding inside tile
        title: Text(
          categoryName.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,  // Spaced letters
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.black),  // Black arrow
        onTap: onTap,  // Handle tap event
      ),
    );
  }
}
