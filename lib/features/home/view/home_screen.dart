import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // 言語に応じたテキストを取得するヘルパーメソッド
  Map<String, String> _getLocalizedTexts(String language) {
    switch (language) {
      case 'ja':
        return {
          'title': '言語選択',
          'description': '言語を選択してください',
          'button': 'ポケモン画像表示へ',
        };
      case 'en':
        return {
          'title': 'Language Selection',
          'description': 'Please select a language',
          'button': 'Go to Pokemon Viewer',
        };
      case 'es':
        return {
          'title': 'Selección de idioma',
          'description': 'Por favor seleccione un idioma',
          'button': 'Ir al visor de Pokemon',
        };
      default:
        return {
          'title': '言語選択',
          'description': '言語を選択してください',
          'button': 'ポケモン画像表示へ',
        };
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final texts = _getLocalizedTexts(selectedLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['title']!),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texts['description']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            DropdownButton<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'ja', child: Text('日本語')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedLanguageProvider.notifier).state = value;
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/image_viewer');
              },
              child: Text(texts['button']!),
            ),
          ],
        ),
      ),
    );
  }
}


