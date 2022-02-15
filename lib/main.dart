import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main_model.dart';

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
      home: const MainPage(),
    );
  }
}

@immutable
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('todo app sample'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          final todoList = model.todoList;
          return ListView(
              children: todoList
                  .map(
                    (todo) => Slidable(
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            onPressed: (BuildContext context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTodoPage(todo),
                                ),
                              );
                              model.getTodoListRealtime();
                            },
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編集',
                          ),
                          const SlidableAction(
                            onPressed: doSomething,
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
                  .toList());
        }),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(model),
                  //　fullscreenDialog: trueにするとpageが右からではなく下から出てくる。
                  fullscreenDialog: true,
                ),
              );
              const snackBar = SnackBar(
                content: Text('追加しました!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Icon(Icons.add),
            tooltip: '未定',
          );
        }),
      ),
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
