import '../../../core/network/api_client.dart';
import '../model/pokemon_model.dart';

class PokemonRepository {
  final ApiClient _apiClient;
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const String speciesBaseUrl = 'https://pokeapi.co/api/v2/pokemon-species';

  // アプリの言語コードをPokeAPIの言語コードにマッピング
  static String _mapLanguageCode(String language) {
    switch (language) {
      case 'ja':
        return 'ja-Hrkt'; // 日本語（ひらがな/カタカナ）
      case 'en':
        return 'en';
      case 'es':
        return 'es';
      default:
        return language;
    }
  }

  PokemonRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<PokemonModel> fetchPokemon(int pokemonId, String language) async {
    // ポケモンの基本情報を取得
    final pokemonUrl = '$baseUrl/$pokemonId';
    final pokemonData = await _apiClient.get(pokemonUrl);
    
    // ポケモン種の情報を取得（多言語対応の名前を取得するため）
    final speciesUrl = '$speciesBaseUrl/$pokemonId';
    final speciesData = await _apiClient.get(speciesUrl);
    
    // 言語に応じた名前を取得
    String pokemonName = pokemonData['name'] as String; // デフォルトは英語名
    if (speciesData['names'] != null) {
      final names = speciesData['names'] as List;
      final apiLanguageCode = _mapLanguageCode(language);
      try {
        final nameForLanguage = names.firstWhere(
          (name) => (name as Map<String, dynamic>)['language']['name'] == apiLanguageCode,
        ) as Map<String, dynamic>;
        pokemonName = nameForLanguage['name'] as String;
      } catch (e) {
        // 指定された言語の名前が見つからない場合はデフォルト名を使用
      }
    }
    
    return PokemonModel(
      name: pokemonName,
      imageUrl: pokemonData['sprites']?['front_default'] as String? ?? '',
      id: pokemonData['id'] as int,
    );
  }
}

