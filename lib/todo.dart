// エンティティを作る。Firestoreのドキュメント自体を扱うためのオブジェクト
// 今回はTodoという名前にしている。扱うフィールドを持たせる。
// 今回はTodoのString titleと 作った時間 DateTime createdAt
class Todo {
  Todo(this.title);
  String title;
}
