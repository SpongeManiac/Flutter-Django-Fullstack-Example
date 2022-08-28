import 'dart:convert';
import 'package:flutter/material.dart';

import 'todo.dart';
import 'package:http/http.dart' as http;

class TodoAPI {
  static String host = 'http://localhost:8000';

  static Uri todosUri = Uri.parse('$host/todos/');

  static String jsonFormat = '?format=json';

  static Future<List<Todo>> getTodos(BuildContext context) async {
    try {
      var uri = Uri.parse('$todosUri$jsonFormat');
      var response = await http.get(uri);
      Iterable listJson = json.decode(response.body);
      List<Todo> todos = List<Todo>.from(listJson.map((i) => Todo.fromJson(i)));
      return todos;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot reach server.'),
        ),
      );
      return [];
    }
  }

  static Future<bool> createTodo(Todo todo) async {
    try {
      var uri = Uri.parse('$todosUri');
      var response = await http.post(uri, body: todo.toJson());
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Todo> readTodo(int id) async {
    try {
      var uri = Uri.parse('$todosUri$id/$jsonFormat');
      var response = await http.get(uri);
      Todo todo = json.decode(response.body);
      return todo;
    } catch (e) {
      return Todo.empty;
    }
  }

  static Future<bool> updateTodo(Todo todo) async {
    try {
      var uri = Uri.parse('$todosUri${todo.id}');
      var response = await http.put(uri, body: todo.toJson());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> delTodo(Todo todo) async {
    try {
      var uri = Uri.parse('$todosUri${todo.id}');
      var response = await http.delete(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
