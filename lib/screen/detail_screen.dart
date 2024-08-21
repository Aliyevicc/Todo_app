import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/todo_model.dart';
import '../service/http_service.dart';
import '../router/app_router.dart';
import 'create_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.toggleTheme,required this.todo, super.key});
  final TodoModel todo;
  final VoidCallback toggleTheme;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> deleteTodo() async {
    await httpService.delete('${Constants.todoPath}/${widget.todo.id}');
    Navigator.of(context).pop();
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('O\'chirish tasdiqlash'),
          content: const Text('Bu to-do ni o\'chirmoqchimisiz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () {
                deleteTodo();
              },
              child: const Text('O\'chirib tashlash'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo #${todo.id}'),
        actions: [
          IconButton(
            onPressed: _showDeleteConfirmationDialog,
            icon: const Icon(CupertinoIcons.trash, color: Colors.red),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreen(todo: todo),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Text(
              todo.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              todo.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
