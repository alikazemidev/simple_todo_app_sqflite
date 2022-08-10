import 'package:facebook_ui_flutter/data/model/todo.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance.updateTodo(
                  Todo(
                    id: selectedId,
                    title: textController.text,
                  ),
                )
              : await DatabaseHelper.instance.addTodo(
                  Todo(
                    title: textController.text,
                  ),
                );
          setState(() {
            textController.clear();
            selectedId = null;
          });
        },
        child: Icon(
          Icons.save,
        ),
      ),
      appBar: AppBar(
        title: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'please add your todo...',
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: DatabaseHelper.instance.getTodos(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text('no todos'),
                  )
                : ListView(
                    children: snapshot.data!.map(
                      (todo) {
                        return Center(
                          child: Card(
                            color: selectedId == todo.id
                                ? Colors.white70
                                : Colors.white,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  if (selectedId == null) {
                                    textController.text = todo.title!;
                                    selectedId = todo.id;
                                  } else {
                                    textController.clear();
                                    selectedId = null;
                                  }
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  DatabaseHelper.instance.removeTodo(todo.id!);
                                });
                              },
                              title: Text(todo.title!),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
          },
        ),
      ),
    );
  }
}
