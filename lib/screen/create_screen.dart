import 'package:flutter/material.dart';

import '../model/todo_model.dart';
import '../service/http_service.dart';

class CreateScreen extends StatefulWidget {
  final TodoModel? todo;

  const CreateScreen({super.key, this.todo});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      title = widget.todo!.title;
      description = widget.todo!.description;
    } else {
      title = '';
      description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.todo == null ? 'Create Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                description = value;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = TodoModel(
            id: widget.todo?.id ?? -1,
            title: title,
            description: description,
            createdAt: widget.todo?.createdAt ?? DateTime.now(),
          );

          bool result;
          if (widget.todo == null) {
            result = await httpService.createTodo(Constants.todoPath, todo);
          } else {
            result = await httpService.updateTodo(Constants.todoPath, todo);
          }

          if (result) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(content: Text('Something went wrong')),
              );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
