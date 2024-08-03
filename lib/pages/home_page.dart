import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todo_app/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  void _loadTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoString = prefs.getString('todo_items');
    if (todoString != null) {
      List decodedItems = jsonDecode(todoString);
      setState(() {
        _todoItems = decodedItems;
      });
    }
  }

  void _saveTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedItems = jsonEncode(_todoItems);
    prefs.setString('todo_items', encodedItems);
  }

  void checkBoxChanged(int index) {
    setState(() {
      _todoItems[index][1] = !_todoItems[index][1];
    });
    _saveTodoItems();
  }

  void _addTodoItem(String task) {
    setState(() {
      _todoItems.add([task, false]);
    });
    _saveTodoItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'TO-DO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return TodoList(
                    todoName: _todoItems[index][0],
                    taskDone: _todoItems[index][1],
                    onChanged: (bool? value) => checkBoxChanged(index),
                    onDelete: () {
                      setState(() {
                        _todoItems.removeAt(index);
                      });
                      _saveTodoItems();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController _textFieldController =
                  TextEditingController();

              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 29, 29, 29),
                title: const Text(
                  'Yeni Görev Ekle',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                      hintText: "Görev girin",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_textFieldController.text.isNotEmpty) {
                        _addTodoItem(_textFieldController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Yazı rengi
                      backgroundColor: const Color.fromARGB(
                          255, 52, 52, 52), // Buton arka plan rengi
                    ),
                    child: const Text('Ekle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 52, 52, 52), // Text color
                    ),
                    child: const Text('İptal'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
