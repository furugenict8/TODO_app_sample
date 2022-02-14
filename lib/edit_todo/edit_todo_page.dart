import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../todo.dart';
import 'edit_todo_model.dart';

class EditTodoPage extends StatelessWidget {
  // entityを受け取るため、constructorの引数に指定しておく。
  const EditTodoPage(this.todo, {Key? key}) : super(key: key);
  // entityを受け取るための変数を用意。
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
                  // TextEditingControllerのtextはmodelで初期化され、
                  // その時に全画面の値が代入されている。
                  // そのため画面が描画されたときにtextが表示される。
                  controller: model.todoEditTextEditingController,
                  onChanged: (text) {
                    // テキストが編集された時にやること。
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // 何かやる。
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
