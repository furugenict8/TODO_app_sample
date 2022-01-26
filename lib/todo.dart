// Kboyさんの動画の書き方とは違うが一旦これでやってみる。
import 'package:cloud_firestore/cloud_firestore.dart';

// エンティティを作る。Firestoreのドキュメント自体を扱うためのオブジェクト
// 今回はTodoという名前にしている。扱うフィールドを持たせる。
// 今回はTodoのString titleと 作った時間 DateTime createdAt
class Todo {
  Todo(DocumentSnapshot doc) {
    title = doc['title'];
    createdAt = doc['createdAt'].toDate();
  }
  String? title;
  DateTime? createdAt;
}
