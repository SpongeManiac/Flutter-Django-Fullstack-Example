import 'dart:convert';
import 'Todo.dart';
import 'package:http/http.dart' as http;

class TodoAPI {
  static String host = 'http://localhost:8000';

  static Uri todosUri = Uri.parse('$host/todos/');

  static String jsonFormat = '?format=json';

  static Future<List<Todo>> getTodos() async {
    print('Getting todos...');
    var uri = Uri.parse('$todosUri$jsonFormat');
    var response = await http.get(uri);
    print('repsonse:\n${response.body}');
    Iterable listJson = json.decode(response.body);
    List<Todo> todos = List<Todo>.from(listJson.map((i) => Todo.fromJson(i)));
    return todos;
  }

  static Future<bool> createTodo(Todo todo) async {
    print('Creating todo...');
    var uri = Uri.parse('$todosUri');
    var response = await http.post(uri, body: todo.toJson());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Todo> readTodo(int id) async {
    print('Getting todo $id...');
    var uri = Uri.parse('$todosUri$id/$jsonFormat');
    var response = await http.get(uri);
    Todo todo = json.decode(response.body);
    return todo;
  }

  static Future<bool> updateTodo(Todo todo) async {
    print('Updating todo ${todo.id}...');
    var uri = Uri.parse('$todosUri${todo.id}');
    var response = await http.put(uri, body: todo.toJson());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> delTodo(int id) async {
    print('Deleting todo $id...');
    var uri = Uri.parse('$todosUri$id/$jsonFormat');
    var response = await http.delete(uri);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
