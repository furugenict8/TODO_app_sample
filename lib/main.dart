import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

@immutable
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Builderサンプル'),
      ),
      body: ListView(children: widgets),
    );
  }
}

// ListViewで表示するためのListTileのList widgets
List<Widget> widgets = todoList
    .map(
      (todo) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                return showConfirmDialog(context, todo);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '削除',
            ),
          ],
        ),
        child: ListTile(
          title: Text(todo),
        ),
      ),
    )
    .toList();

// todoのList
List<String> todoList = ['ゴミを出す', 'スッキリJava読む', '就職面接にいく'];

// 削除確認画面(AlertDialog)を表示するメソッド
// 「いいえ」をタップすると元に戻る。
void showConfirmDialog(BuildContext context, String todo) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: const Text("削除の確認"),
        content: Text('"$todo"を削除しますか？'),
        actions: [
          Builder(builder: (context) {
            return TextButton(
              child: const Text("いいえ(エラーにならない)"),
              onPressed: () => Navigator.pop(context),
            );
          }),
          TextButton(
            child: const Text("はい"),
            onPressed: () => deleteTodo,
          ),
        ],
      );
    },
  );
}

// 削除確認用のダイアログで「いいえ」ボタンのTextButtonをWidgetで作る。
class NoButtonInConfirmDialog extends StatelessWidget {
  const NoButtonInConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text("いいえ"),
      onPressed: () => Navigator.pop(context),
    );
  }
}

// 「はい」ボタンを押してtodoを削除する処理
void deleteTodo(BuildContext context) {
  // do something
}
