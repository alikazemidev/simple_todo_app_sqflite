import 'package:facebook_ui_flutter/data/model/todo.dart';
import 'package:facebook_ui_flutter/screens/add_todo_screen.dart';
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
  PageController pageController = PageController();

  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                var outPut = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoScreen(),
                  ),
                );
                setState(() {
                  result = outPut;
                });
              },
              icon: Icon(Icons.add))
        ],
        title: const Text(
          'Sqflite todo app',
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: DatabaseHelper.instance.getTodos(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('loading..'),
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
                          child: ListTile(
                            title: Text(todo.title!),
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
