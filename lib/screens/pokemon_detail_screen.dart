import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/services/pokeapi_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonName;

  PokemonDetailScreen({required this.pokemonName});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Map<String, dynamic> pokemonDetails = {};

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails();
  }

  Future<void> fetchPokemonDetails() async {
    final details = await PokeApiService.fetchPokemonDetails(widget.pokemonName);
    setState(() {
      pokemonDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('${widget.pokemonName}', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: pokemonDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.red[100], // Light red background like Pokedex theme
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pokedex-like card for the swiper
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    color: Colors.red[400],
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 250,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: false,
                          ),
                          items: _buildSpriteSwiper(pokemonDetails['sprites']),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  Text(
                    'Nombre: ${widget.pokemonName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Pokémon Height and Weight
                  _buildDetailRow('Altura', pokemonDetails['height'].toString(), Icons.height),
                  _buildDetailRow('Peso', pokemonDetails['weight'].toString(), Icons.line_weight),
                  
                  SizedBox(height: 12),
                  
                  // Abilities section in a rounded card
                  Text('Habilidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  Card(
                    color: Colors.yellow[300], // Yellow like the buttons on a Pokedex
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var ability in pokemonDetails['abilities'])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '• ${ability['ability']['name']}',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSpriteSwiper(Map<String, dynamic> sprites) {
    List<Widget> spriteWidgets = [];

    if (sprites['front_default'] != null)
      spriteWidgets.add(Image.network(sprites['front_default'], fit: BoxFit.contain));
    if (sprites['back_default'] != null)
      spriteWidgets.add(Image.network(sprites['back_default'], fit: BoxFit.contain));
    if (sprites['front_shiny'] != null)
      spriteWidgets.add(Image.network(sprites['front_shiny'], fit: BoxFit.contain));
    if (sprites['back_shiny'] != null)
      spriteWidgets.add(Image.network(sprites['back_shiny'], fit: BoxFit.contain));

    return spriteWidgets;
  }
}
