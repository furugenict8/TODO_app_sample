import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';

class EditTodoModel extends ChangeNotifier {
  // entityを受け取るためにconstructorを初期化処理。
  EditTodoModel(this.todo) {
    // TextEditingControllerのtextに引数で受け取ったentityのtextを入れる。
    todoEditTextEditingController.text = todo.title;
  }

  //　constructorで初期化するためのTodo(entity)を定義しておく。
  Todo todo;

  // updateの時に入力されるtext
  String? updateTodoText;

  // TextFieldで入力されたtextを扱うためのTextEditingController
  final TextEditingController todoEditTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    todoEditTextEditingController.dispose();
    super.dispose();
  }
}
