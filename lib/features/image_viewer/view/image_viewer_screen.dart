import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../home/provider/home_provider.dart';
import '../provider/image_viewer_provider.dart';

class ImageViewerScreen extends ConsumerWidget {
  const ImageViewerScreen({super.key});

  // 言語に応じたテキストを取得するヘルパーメソッド
  Map<String, String> _getLocalizedTexts(String language) {
    switch (language) {
      case 'ja':
        return {
          'title': 'ポケモンAPI学習',
          'previous': '前のポケモンへ',
          'next': '次のポケモンへ',
          'inputLabel': 'ポケモンの番号を入力',
          'specify': 'ポケモンを指定する',
          'reload': 'もう一度読み込む',
          'error': 'エラーが発生しました',
          'retry': '再試行',
        };
      case 'en':
        return {
          'title': 'Pokemon API Learning',
          'previous': 'Previous Pokemon',
          'next': 'Next Pokemon',
          'inputLabel': 'Enter Pokemon Number',
          'specify': 'Specify Pokemon',
          'reload': 'Reload',
          'error': 'An error occurred',
          'retry': 'Retry',
        };
      case 'es':
        return {
          'title': 'Aprendizaje de API de Pokemon',
          'previous': 'Pokemon Anterior',
          'next': 'Siguiente Pokemon',
          'inputLabel': 'Ingrese el Número de Pokemon',
          'specify': 'Especificar Pokemon',
          'reload': 'Recargar',
          'error': 'Ocurrió un error',
          'retry': 'Reintentar',
        };
      default:
        return {
          'title': 'ポケモンAPI学習',
          'previous': '前のポケモンへ',
          'next': '次のポケモンへ',
          'inputLabel': 'ポケモンの番号を入力',
          'specify': 'ポケモンを指定する',
          'reload': 'もう一度読み込む',
          'error': 'エラーが発生しました',
          'retry': '再試行',
        };
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonId = ref.watch(currentPokemonIdProvider);
    final pokemonAsync = ref.watch(pokemonProvider(pokemonId));
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final texts = _getLocalizedTexts(selectedLanguage);
    final inputController = TextEditingController();

    void countupPokemon() {
      ref.read(currentPokemonIdProvider.notifier).state += 1;
    }

    void countdownPokemon() {
      final currentId = ref.read(currentPokemonIdProvider);
      if (currentId > 1) {
        ref.read(currentPokemonIdProvider.notifier).state -= 1;
      }
    }

    void countInputPokemon(String input) {
      final id = int.tryParse(input);
      if (id != null && id > 0) {
        ref.read(currentPokemonIdProvider.notifier).state = id;
      }
    }

    void refreshPokemon() {
      ref.invalidate(pokemonProvider(pokemonId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['title']!),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: pokemonAsync.when(
          data: (pokemon) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ポケモンの画像表示
              pokemon.imageUrl.isNotEmpty
                  ? Image.network(
                      pokemon.imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const LoadingWidget(),
              const SizedBox(height: 20),
              // ポケモンの名前表示
              Text(
                pokemon.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // 前へ・次へボタンを横並びに
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: countdownPokemon,
                    child: Text(texts['previous']!),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: countupPokemon,
                    child: Text(texts['next']!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // カウント入力
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    labelText: texts['inputLabel']!,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              // ポケモンを指定するボタン
              ElevatedButton(
                onPressed: () => countInputPokemon(inputController.text),
                child: Text(texts['specify']!),
              ),
              const SizedBox(height: 20),
              // 再読み込みボタン
              ElevatedButton(
                onPressed: refreshPokemon,
                child: Text(texts['reload']!),
              ),
            ],
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${texts['error']!}: $error',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: refreshPokemon,
                child: Text(texts['retry']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

