import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: const Text(
          "MyApp",
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      frontLayer: _buildSuggestions(),
      backLayer: Container(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          child: Text("Favourites"),
          onPressed: _pushSaved,
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
        ),
      ),
      headerHeight: 700,
      backLayerBackgroundColor: Colors.black,
      frontLayerBackgroundColor: Colors.black,
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final _savedTrue = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          decorationColor: Colors.white,
        ),
      ),
      trailing: Icon(
        _savedTrue ? Icons.favorite : Icons.favorite_border,
        color: _savedTrue ? Colors.red : Colors.white,
      ),
      onTap: () {
        setState(() {
          if (_savedTrue) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    decorationColor: Colors.white,
                  ),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
              backgroundColor: Colors.black,
            ),
            body: ListView(children: divided),
            backgroundColor: Colors.black,
          );
        },
      ),
    );
  }
}
