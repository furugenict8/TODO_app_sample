import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../todo.dart';
import 'edit_todo_model.dart';

class EditTodoPage extends StatelessWidget {
  // Todoを受け取るため、constructorの引数に指定しておく。
  const EditTodoPage(this.todo, {Key? key}) : super(key: key);
  // Todoを受け取るための変数を用意。
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTodoModel>(
      // 受け取ったentityをさらにモデルにわたす。
      create: (_) => EditTodoModel(todo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('編集画面'),
        ),
        body: Consumer<EditTodoModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  // TextEditingControllerのtextはmodelで初期化されているので、
                  // 前の画面のtextを持っている。
                  // そのため画面が描画されたときにtextが表示される。
                  controller: model.todoEditTextEditingController,
                  onChanged: (text) {
                    // 入力欄でテキストが編集された時にやること。
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // 入力されたtextを元にデータベースを更新する処理などをやる
                  },
                  child: const Text('編集'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
