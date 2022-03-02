import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';

class EditTodoModel extends ChangeNotifier {
  EditTodoModel(this.todo) {
    todoEditTextEditingController.text = todo.title!;
  }

  //　modelで使うためのTodoを定義。edit_book_page.dartからTodoをモデルに持ってくる。
  Todo todo;

  // updateの時に入力されるtext
  String? updateTodoText;

  // TextFieldで入力されたtextを扱うためのTextEditingController
  final TextEditingController todoEditTextEditingController =
      TextEditingController();

  // updateTodoTextがnullじゃないか判定。nullじゃなければtrueを返す。
  // nullならupdateしないようにするために用意。
  bool isUpdated() {
    return updateTodoText != null;
  }

  // Firestoreのcollection(今回はtodoList)を取得しておく。
  CollectionReference collection =
      FirebaseFirestore.instance.collection('todoList');

  void setTitle(String text) {
    updateTodoText = text;
    notifyListeners();
  }

  // Firestoreに値を追加するためのadd method
  // FirebaseがらみなのでFutureになってる多分。
  Future<void>? update() async {
    // バリデーション
    if (updateTodoText == '') {
      throw 'タイトルが入っていません！';
    }
    // CollectionReferenceのadd()はFutureを返すのでawaitしとく。
    await collection.doc(todo.documentID).update({
      'title': updateTodoText,
      'createdAt': Timestamp.now(),
    });
    notifyListeners();
  }

  @override
  void dispose() {
    todoEditTextEditingController.dispose();
    super.dispose();
  }
}
