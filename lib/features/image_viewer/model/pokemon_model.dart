class PokemonModel {
  final String name;
  final String imageUrl;
  final int id;

  PokemonModel({
    required this.name,
    required this.imageUrl,
    required this.id,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'] as String,
      imageUrl: json['sprites']['front_default'] as String? ?? '',
      id: json['id'] as int,
    );
  }
}

