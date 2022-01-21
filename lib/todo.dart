// Kboyさんの動画の書き方とは違うが一旦これでやってみる。
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  Todo(DocumentSnapshot doc) {
    // doc.data()の型がObject型になっているのが原因かな。なぜ？
    Map docMap = doc.data() as Map<String, dynamic>;
    title = docMap!['title'];
    createdAt = docMap!['createdAt'];
  }
  Map? docMap;
  String? title;
  DateTime? createdAt;
}
