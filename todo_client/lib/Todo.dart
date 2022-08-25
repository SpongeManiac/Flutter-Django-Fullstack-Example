class Todo {
  String title;
  String description;
  bool completed;

  Todo(this.title, this.description, this.completed);
  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'completed': completed,
      };
}
