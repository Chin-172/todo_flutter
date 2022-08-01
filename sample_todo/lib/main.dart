import 'package:flutter/material.dart';

void main() => runApp(
  const TodoApp()
);

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TodoApp',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  final TextEditingController _textEditingController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  void _handleTodoChange(Todo todo){
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addToItem(String itemName){
    setState(() {
      _todos.add(Todo(name: itemName,checked: false));
    });

    _textEditingController.clear();
  }
  Future<void> _displayDialog() async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Adding New Item"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "New Item..."
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop();
              _addToItem(_textEditingController.text);
            }, child: const Text("Add"))
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo){
          return TodoItem(todo: todo, onTodoChanged: _handleTodoChange);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _displayDialog();
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo{
  final String name;
  bool checked;

  Todo({required this.name, required this.checked});
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final onTodoChanged;

  const TodoItem({required this.todo, required this.onTodoChanged}) : super(key: const ObjectKey(Todo));

  TextStyle? _getTextStyle(bool checked){
    if (!checked) {
      return null;
    }

    return const TextStyle(
      color: Colors.grey,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked),),
    );
  }
}