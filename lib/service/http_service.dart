import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/todo_model.dart';

class Constants {
  static const todoPath = '/todos';
}

const httpService = HttpService('https://66c1db77f83fffcb587a672c.mockapi.io');

class HttpService {
  const HttpService(this.baseUrl);

  final String baseUrl;

  Future<TodoModel?> getById(String path, int id) async {
    try {
      final url = Uri.parse('$baseUrl$path/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, Object?> json = jsonDecode(response.body);
        return TodoModel.fromJson(json);
      } else {
        return null;
      }
    } on Object catch (e, s) {
      print('$e\n$s');
      return null;
    }
  }

  Future<List<TodoModel>> getAll(String path) async {
    try {
      final url = Uri.parse('$baseUrl$path');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List json = jsonDecode(response.body);
        final result = json.map((e) => TodoModel.fromJson(e)).toList();
        return result;
      } else {
        return [];
      }
    } on Object catch (e, s) {
      print('$e\n$s');
      return [];
    }
  }

  Future<bool> createTodo(String path, TodoModel todo) async {
    try {
      final url = Uri.parse('$baseUrl$path');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(todo.toJson());

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create todo: ${response.statusCode}');
        return false;
      }
    } on Object catch (e, s) {
      print('$e\n$s');
      return false;
    }
  }

  Future<bool> updateTodo(String path, TodoModel todo) async {
    try {
      final url = Uri.parse('$baseUrl$path/${todo.id}');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(todo.toJson());

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update todo: ${response.statusCode}');
        return false;
      }
    } on Object catch (e, s) {
      print('$e\n$s');
      return false;
    }
  }

  Future<bool> delete(String path) async {
    try {
      final url = Uri.parse('$baseUrl$path');
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete todo: ${response.statusCode}');
        return false;
      }
    } on Object catch (e, s) {
      print('$e\n$s');
      return false;
    }
  }
}
