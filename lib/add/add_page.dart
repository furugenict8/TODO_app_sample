import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_model.dart';

class AddPage extends StatelessWidget {
  // main_modelからmodelを持ってきておく。
  final MainModel model;
  const AddPage(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // すでに別のChangeNotifierProviderでcreateされているmodel(今回はMainModel)
    // を使い回すため、.valueで書いている。書き方は以下
    return ChangeNotifierProvider<MainModel>.value(
      value: MainModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新規追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "追加するTODO",
                    hintText: "ゴミを出す",
                  ),
                  onChanged: (text) {
                    model.newTodoText = text;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // model.add()のexceptionをtry catchでキャッチさせる
                    try {
                      // Firestoreに値を追加する。
                      await model.add();
                      //　追加ボタンを押したあと画面を閉じる。
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      // exceptionがあったらSnackBarで表示させる。
                      SnackBar snackBar = SnackBar(
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('追加'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
