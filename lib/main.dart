import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main_model.dart';
import 'package:todoapp/todo.dart';

import 'add/add_page.dart';
import 'edit_todo/edit_todo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

@immutable
class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoList(),
      // ScaffoldMessengerにkeyを持たせるため、ScaffoldをScaffoldMessengerでwrap
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('todo app sample'),
          ),
          body: Consumer<MainModel>(builder: (context, model, child) {
            final List<Todo> todoList = model.todoList;
            final List<Widget> widgets = todoList
                .map(
                  (todo) => Slidable(
                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            // Navigator.popの引数の値がここに返ってくるので、変数で受け取る。
                            final String? updateTodoText = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTodoPage(todo),
                              ),
                            );
                            // 上で受け取った値でif文を使った処理をしている。
                            if (updateTodoText != null) {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('"$updateTodoText"を更新しました！'),
                              );
                              _scaffoldMessengerKey.currentState
                                  ?.showSnackBar(snackBar);
                            }
                            model.getTodoListRealtime();
                          },
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: '編集',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            return showConfirmDialog(context, todo, model);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '削除',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(todo.title!),
                    ),
                  ),
                )
                .toList();
            return ListView(children: widgets);
          }),
          floatingActionButton:
              Consumer<MainModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                // Navigator.push()をbool変数に入れる。
                //　AddPage()では編集ボタンを押すとNavigator.pop(true)で
                // このNavigator.pushに戻ってくるが、今回はtrueを持っているので、
                // trueがaddedに代入される。
                // AddPage側の編集ボタンを押した時に呼ばれるadd()では
                // バリデーションで文字が入った時のみ更新されてNavigator.pop→Navigator.pushに
                // 戻ってくるようになっているので、実質戻ったらtrueが必ず入る。
                //　コードはhttps://youtu.be/nPAIXqGzjUM?t=1314
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(model),
                    //　fullscreenDialog: trueにするとpageが右からではなく下から出てくる。
                    fullscreenDialog: true,
                  ),
                );
                // addedにNavigator.push()の戻り値(true)が入っている
                // == AddPageで編集ボタンを押した時にTextFieldに文字が入っている
                // ということ。
                // addedにはnullかtrueどっちかが入るので以下の条件になっている。
                // が、bool?ではなくboolにして
                // ifの条件式もaddedだけでいい気がするが
                // どっちも条件に入れるのはよくわかっていない。
                if (added != null && added) {
                  SnackBar snackBar = const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('todoを追加しました！'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.getTodoListRealtime();
              },
              child: const Icon(Icons.add),
              tooltip: '未定',
            );
          }),
        ),
      ),
    );
  }

  void showConfirmDialog(
    BuildContext context,
    Todo todo,
    MainModel model,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text('"${todo.title}"を削除しますか？'),
          actions: [
            Builder(builder: (context) {
              return TextButton(
                child: const Text("いいえ"),
                onPressed: () => Navigator.pop(context),
              );
            }),
            Builder(builder: (context) {
              return TextButton(
                child: const Text("はい"),
                onPressed: () async {
                  // FirestoreのDeleteを実装する。
                  await model.deleteTodo(todo);
                  Navigator.pop(context);
                  SnackBar snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${todo.title}を削除しました。！'),
                  );
                  model.getTodoListRealtime();
                  _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                },
              );
            }),
          ],
        );
      },
    );
  }
}

void doSomething(BuildContext context) {}
void deleteBookTitle(BuildContext context) {
  // TODO(me): 削除アイコンをタップした時の削除処理
  // 削除するかどうかを聞いて、OKなら削除
}

//いったん保留
// void editBookTitle(BuildContext context) {
//   // TODO(me): 編集アイコンをタップした時の編集処理
//   // 編集画面に遷移
//   // 編集画面は追加画面とほぼ同じでいい
//   //　本来は追加画面を使いまわしたほうがいいらしい。
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const EditBookPage(),
//     ),
//   );
// }

//　ちょっと保留。
// slidableなListTileを作る。
// class SlidableListTile extends StatelessWidget {
//   const SlidableListTile(this.todo, {Key? key}) : super(key: key);
//
//   // 引数にTodoを持たせる。
//   final Todo todo;
//
//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       // Specify a key if the Slidable is dismissible.
//       key: const ValueKey(0),
//
//       // The start action pane is the one at the left or the top side.
//       // 左側または上側にあるのがスタートアクションペインです。
//       startActionPane: ActionPane(
//         // A motion is a widget used to control how the pane animates.
//         // モーションは、ペインのアニメーションを制御するためのウィジェットです。
//         motion: const ScrollMotion(),
//
//         // A pane can dismiss the Slidable.
//         dismissible: DismissiblePane(onDismissed: () {}),
//
//         // All actions are defined in the children parameter.
//         children: const [
//           // A SlidableAction can have an icon and/or a label.
//           SlidableAction(
//             // 何かやる。
//             onPressed: deleteBookTitle,
//             backgroundColor: Color(0xFFFE4A49),
//             foregroundColor: Colors.white,
//             icon: Icons.delete,
//             label: 'Delete',
//           ),
//           SlidableAction(
//             //　何かやる。
//             onPressed: editBookTitle,
//             backgroundColor: Color(0xFF21B7CA),
//             foregroundColor: Colors.white,
//             icon: Icons.share,
//             label: 'Share',
//           ),
//         ],
//       ),
//
//       // The end action pane is the one at the right or the bottom side.
//       endActionPane: const ActionPane(
//         motion: ScrollMotion(),
//         children: [
//           SlidableAction(
//             // An action can be bigger than the others.
//             flex: 2,
//             onPressed: doSomething,
//             backgroundColor: Color(0xFF7BC043),
//             foregroundColor: Colors.white,
//             icon: Icons.archive,
//             label: 'Archive',
//           ),
//           SlidableAction(
//             onPressed: doSomething,
//             backgroundColor: Color(0xFF0392CF),
//             foregroundColor: Colors.white,
//             icon: Icons.save,
//             label: 'Save',
//           ),
//         ],
//       ),
//
//       // The child of the Slidable is what the user sees when the
//       // component is not dragged.
//       child: ListTile(
//         title: Text(todo.title!),
//       ),
//     );
//   }
// }
