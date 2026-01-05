import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/provider/home_provider.dart';
import '../model/pokemon_model.dart';
import '../repository/pokemon_repository.dart';

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository();
});

final currentPokemonIdProvider = StateProvider<int>((ref) => 1);

final pokemonProvider = FutureProvider.family<PokemonModel, int>((ref, pokemonId) async {
  final repository = ref.watch(pokemonRepositoryProvider);
  final language = ref.watch(selectedLanguageProvider);
  return await repository.fetchPokemon(pokemonId, language);
});

