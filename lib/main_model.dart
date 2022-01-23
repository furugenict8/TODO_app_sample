import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];
  Future getTodoList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList;
    notifyListeners();
  }

  //　データベースがリアルタイムで更新されたらアプリも更新される。
  void getTodoListRealtime() {
    // snapshotsはstream型。流れてくる。
    final snapshot =
        FirebaseFirestore.instance.collection('todoList').snapshots();
    // listen()でstreamで流れてきた値を受け取って更新する。
    snapshot.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      this.todoList = todoList;
      //　順番並べ替えのメソッドsort() 新しい順に変更。
      todoList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      notifyListeners();
    });
  }
}
