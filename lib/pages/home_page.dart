import 'package:flutter/material.dart';
import 'package:todo_app/utils/todo_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      setState(() {
        to_do_list = List.from(json.decode(tasksString));
      });
    }
  }

  _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(to_do_list));
  }

  List to_do_list = [];

  void onChangedCheckbox(int index) {
    setState(() {
      to_do_list[index][1] = !to_do_list[index][1];
      _saveTasks();
    });
  }

  void saveTask() {
    setState(() {
      if (_controller.text != "") {
        to_do_list.add([_controller.text, false]);
        _controller.clear();
        _saveTasks();
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      to_do_list.removeAt(index);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 20, 45),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 5),
        title: const Text(
          'To Do',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: FractionallySizedBox(
        heightFactor: 0.8,
        child: ListView.builder(
            itemCount: to_do_list.length,
            itemBuilder: (BuildContext context, index) {
              return TodoList(
                taskName: to_do_list[index][0],
                taskCompleted: to_do_list[index][1],
                onChanged: (value) => onChangedCheckbox(index),
                deleteFunction: (context) => deleteTask(index),
              );
            }),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 20,
            ),
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _controller,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 19,
              ),
              decoration: InputDecoration(
                hintText: 'Add Tasks',
                filled: true,
                fillColor: const Color.fromARGB(255, 200, 222, 215),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 4, 4, 47),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          )),
          FloatingActionButton(
            onPressed: saveTask,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
