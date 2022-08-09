import 'package:facebook_ui_flutter/data/model/todo.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final textController = TextEditingController();
  String inputText = '';
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseHelper.instance
              .addTodo(Todo(title: textController.text));
          setState(() {
            inputText = textController.text;
            textController.clear();
          });
          Navigator.pop(context, inputText);
        },
        child: Icon(
          Icons.save,
        ),
      ),
      body: SafeArea(
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'please add your todo...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
