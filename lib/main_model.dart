import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';

class MainModel extends ChangeNotifier {
  // todoListを手動で作成
  List<Todo> todoList = [Todo('トイレ掃除'), Todo('犬の散歩')];

  //　'title'フィールドに入力するためのtodoTextを用意
  String newTodoText = '';
}
