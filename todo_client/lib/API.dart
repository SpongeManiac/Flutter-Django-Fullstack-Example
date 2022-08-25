import 'dart:convert';
import 'Todo.dart';
import 'package:http/http.dart' as http;

class TodoAPI {
  static Uri todosEndpoint =
      Uri.parse('http://localhost:8000/todos/?format=json');

  static Future<List<Todo>> getTodos() async {
    print('Getting todos...');
    var response = await http.get(todosEndpoint);
    print('response: $response');
    Iterable listJson = json.decode(response.body);
    List<Todo> todos = List<Todo>.from(listJson.map((i) => Todo.fromJson(i)));
    print('todos length: ${todos.length}');
    return todos;
  }
}
