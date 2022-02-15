import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';

class MainModel extends ChangeNotifier {
  // todoListを手動で作成。ListViewで表示するためListにしておく。
  List<Todo> todoList = [Todo('トイレ掃除'), Todo('犬の散歩')];
}
