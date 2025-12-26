import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポケモンAPI学習',
      home: PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  // データを保存する変数
  String pokemonName = '読み込み中...';
  String pokemonImage = '';

  // データを読み込む関数
  @override
  void initState() {
    super.initState();
    // 画面が表示されたら自動的にデータを取得
    fetchPokemon();
  }

  // APIからデータを取得する関数
  Future<void> fetchPokemon() async {
    // APIのURL ピカチュウ
    final url = 'https://pokeapi.co/api/v2/pokemon/25';

    try {
      // HTTPリクエストを送信
    final response = await http.get(Uri.parse(url));

    // リクエストが成功したかどうかを確認
    if (response.statusCode == 200) {
      // JSONデータを解析
      final data = jsonDecode(response.body);

      setState(() {
        pokemonName = data['name'];
        pokemonImage = data['sprites']['front_default'];
      });

      debugPrint('【取得成功】ポケモン名: $pokemonName');
      debugPrint('【取得成功】ポケモン画像: $pokemonImage');
    } else {
      debugPrint('【取得失敗】リクエストに失敗しました: ${response.statusCode}');
    }
    } catch (error) {
      debugPrint('エラーが発生しました: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポケモンAPI学習'),
        backgroundColor: Colors.blue,
        ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ポケモンの画像表示
          pokemonImage.isNotEmpty ? Image.network(
            pokemonImage,width: 200,height: 200,fit: BoxFit.cover,) : CircularProgressIndicator(), // 読み込み中はローディング
          
          
          SizedBox(height: 20),

          // ポケモンの名前表示
          Text(pokemonName,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),

          SizedBox(height: 40),
          
          // 再読み込みボタン
          ElevatedButton(onPressed: fetchPokemon, child: Text('もう一度読み込む'))
        ],
        ),
      ),
    );
  }
}