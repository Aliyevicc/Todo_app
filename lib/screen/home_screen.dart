import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo_model.dart';
import '../router/app_router.dart';
import '../service/http_service.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.toggleTheme, super.key});

  final VoidCallback toggleTheme;

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(right: 237),
          child: Text(
            'Todo',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () => AppRouter.createScreen(context),
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          getTodos();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    title: Text(
                      '${todo.id} | ${todo.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      todo.description,
                    ),
                    trailing: Text(
                      DateFormat('hh:mm a | dd MMM yyyy').format(todo.createdAt),
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    onTap: () => AppRouter.detailScreen(context, todo),
                    onLongPress: () => _showDeleteConfirmationDialog(todo),
                  );
                },
              ),
            ),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 90, top: 7),
                child: Text(
                  "Your Todos!",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
