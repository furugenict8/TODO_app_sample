import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main_model.dart';

import 'edit_todo/edit_todo_page.dart';

Future<void> main() async {
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
      create: (_) => MainModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TextFieldに初期値を持たせるサンプル'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          final todoList = model.todoList;
          return ListView(
              children: todoList
                  .map((todo) => ListTile(
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            //Todo :画面遷移
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                // 遷移先のページEditTodoPage()にentityをわたす
                                builder: (context) => EditTodoPage(todo),
                              ),
                            );
                          },
                        ),
                        title: Text(todo.title),
                      ))
                  .toList());
        }),
      ),
    );
  }
}
