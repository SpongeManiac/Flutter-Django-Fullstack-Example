class Todo {
  int id;
  String title;
  String description;
  bool completed;

  Todo(this.title, this.description, this.completed, {this.id = -1});
  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'completed': completed.toString(),
      };
}
