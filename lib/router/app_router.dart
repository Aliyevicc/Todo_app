import 'package:flutter/material.dart';
import '../model/todo_model.dart';
import '../screen/create_screen.dart';
import '../screen/detail_screen.dart';

class AppRouter {
  const AppRouter._();

  static const home = 'home/';
  static const detail = 'detail/';
  static const create = 'create/';

  static Future<void> detailScreen(BuildContext context, TodoModel todo) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DetailScreen(todo: todo, toggleTheme: () {},),
        ),
      );

  static Future<void> createScreen(BuildContext context) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const CreateScreen(),
        ),
      );
}
