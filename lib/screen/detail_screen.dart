import 'package:flutter/material.dart';
import '../model/todo_model.dart';
import '../service/http_service.dart';
import '../router/app_router.dart';
import 'create_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.todo, super.key});

  final TodoModel todo;

  Future<void> deleteTodo() async {
    await httpService.delete('${Constants.todoPath}/${todo.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo #${todo.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreen(todo: todo),
                ),
              ).then((_) {
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 100.0),
            TextButton(
              onPressed: () {
                deleteTodo().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todo deleted')),
                  );
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
