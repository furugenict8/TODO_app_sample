import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../todo.dart';
import 'edit_todo_model.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage(this.todo, {Key? key}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // すでに別のChangeNotifierProviderでcreateされているmodel(今回はMainModel)
    // を使い回すため、.valueで書いている。書き方は以下
    return ChangeNotifierProvider<EditTodoModel>(
      create: (_) => EditTodoModel(todo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('編集'),
        ),
        body: Consumer<EditTodoModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // TODO(me): TextEditingControllerを使って、デフォルトのテキストを元々ListTileの持っているテキストにする。
                TextField(
                  controller: model.todoEditTextEditingController,
                  onChanged: (text) {
                    model.setTitle(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: model.isUpdated()
                      ? () async {
                          try {
                            // Firestoreに値を追加する。
                            await model.update();
                            String? updateTodoText = model.updateTodoText;
                            //　追加ボタンを押したあと画面を閉じる。
                            Navigator.of(context).pop(updateTodoText);
                          } catch (e) {
                            //TODO(): update()でexceptionが発生した時の処理。
                            SnackBar snackBar = SnackBar(
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      // onPressedはnullが入ると、非活性化（グレーアウトしてボタンが押せない）
                      : null,
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
