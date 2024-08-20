import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/todo_model.dart';
import '../router/app_router.dart';
import '../service/http_service.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TodoModel> todos = [];

  void getTodos() async {
    final result = await httpService.getAll(Constants.todoPath);

    setState(() {
      todos = [];
      todos.addAll(result);
    });
  }

  Future<void> deleteTodo(TodoModel todo) async {

    await httpService.delete('${Constants.todoPath}/${todo.id}');

    getTodos();
  }


  void _showDeleteConfirmationDialog(TodoModel todo) {
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
                deleteTodo(todo);
                Navigator.of(context).pop();
              },
              child: const Text('O\'chirib tashlash'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getTodos();
        },
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return ListTile(
              title: Text('(${todo.id}) ${todo.title}'),
              subtitle: Text(todo.description),
              trailing: Text(DateFormat('hh:mm a | dd MMM yyyy').format(todo.createdAt)),
              onTap: () => AppRouter.detailScreen(context, todo),
              onLongPress: () => _showDeleteConfirmationDialog(todo),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppRouter.createScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
