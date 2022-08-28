import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_client/todo_api.dart';
import 'package:todo_client/crud_page.dart';

import 'base_page.dart';
import 'todo.dart';
import 'hideable_floating_action.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter/Django Fullstack App'),
    );
  }
}

class MyHomePage extends BasePage {
  const MyHomePage({super.key, required super.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends CRUDState<Todo> {
  ValueNotifier<HideableFloatingActionData> floatingActionNotifierRight =
      ValueNotifier(HideableFloatingActionData(false));

  ValueNotifier<HideableFloatingActionData> floatingActionNotifierLeft =
      ValueNotifier(HideableFloatingActionData(false));

  TextEditingController titleField = TextEditingController();
  TextEditingController descriptionField = TextEditingController();
  bool completed = false;

  Future<List<Todo>> getTodos() async {
    return await TodoAPI.getTodos(context);
  }

  Widget get todoForm => Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: titleField,
                validator: (value) => validateTitle(value),
                maxLength: 128,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                controller: descriptionField,
                validator: (value) => validateDesc(value),
                maxLength: 1024,
              ),
              CheckboxListTile(
                title: const Text('Completed'),
                value: completed,
                onChanged: (value) {
                  setState(() {
                    completed = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      );
  final GlobalKey formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    floatingActionNotifierRight.value = HideableFloatingActionData(
      true,
      () async {
        await setCreate();
      },
      const Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
    );
  }

  String? validateTitle(String? val) {
    val = val ?? '';
    if (val.isEmpty || val.trim().isEmpty) return 'Please enter some text.';
    return null;
  }

  String? validateDesc(String? val) {
    val = val ?? '';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: super.build(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HideableFloatingAction(
                floatingActionNotifier:
                    floatingActionNotifierLeft), // This trailing comma makes auto-formatting nicer for build methods.
            HideableFloatingAction(
                floatingActionNotifier: floatingActionNotifierRight),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> setCreate() async {
    floatingActionNotifierLeft.value = HideableFloatingActionData(
      true,
      () async {
        await cancel();
      },
      const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
      ),
    );
    floatingActionNotifierRight.value = HideableFloatingActionData(
      true,
      () async {
        var todo = await create();
        if (todo.id != -1) await setRead();
      },
      const Icon(
        Icons.send_rounded,
        color: Colors.white,
      ),
    );
    titleField.text = '';
    descriptionField.text = '';
    completed = false;
    await super.setCreate();
  }

  @override
  Future<void> setRead() async {
    floatingActionNotifierRight.value = HideableFloatingActionData(
      true,
      () async {
        await setCreate();
      },
      const Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
    );
    floatingActionNotifierLeft.value = HideableFloatingActionData(
      false,
    );
    titleField.text = '';
    descriptionField.text = '';
    completed = false;
    itemToEdit = null;
    await super.setRead();
  }

  @override
  Future<void> setUpdate(Todo todo) async {
    itemToEdit = todo;
    floatingActionNotifierLeft.value = HideableFloatingActionData(
      true,
      () async {
        await setRead();
      },
      const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
      ),
    );
    floatingActionNotifierRight.value = HideableFloatingActionData(
      true,
      () async {
        Todo todo = Todo(titleField.text, descriptionField.text, completed);
        todo.id = itemToEdit!.id;
        itemToEdit = todo;
        await TodoAPI.updateTodo(todo);
        await setRead();
      },
      const Icon(
        Icons.send_rounded,
        color: Colors.white,
      ),
    );
    titleField.text = itemToEdit!.title;
    descriptionField.text = itemToEdit!.description;
    completed = itemToEdit!.completed;
    super.setUpdate(todo);
  }

  @override
  Future<Todo> create() async {
    FormState formState = formKey.currentState as FormState;
    if (formState.validate()) {
      Todo todo =
          Todo(titleField.text, descriptionField.text, completed, id: -2);
      if (await TodoAPI.createTodo(todo)) return todo;
    }
    return Todo.empty;
  }

  @override
  Future<Todo> update(Todo item) async {
    if (await TodoAPI.updateTodo(item)) {
      return await TodoAPI.readTodo(item.id);
    } else {
      return Todo.empty;
    }
  }

  @override
  Future<void> delete(Todo item) async {
    await TodoAPI.delTodo(item);
    setState(() {});
  }

  @override
  Widget createView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: todoForm,
          ),
        ],
      ),
    );
  }

  @override
  Widget readView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: getTodos(),
              builder: (context, snapshot) {
                List<Todo> list = snapshot.data ?? [];
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        Todo item = list[index];
                        return ListTile(
                          onTap: () async {
                            var newTodo = item;
                            newTodo.completed = !newTodo.completed;
                            await TodoAPI.updateTodo(newTodo);
                            setState(() {});
                          },
                          onLongPress: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Todo Options'),
                                    actions: [
                                      ListTile(
                                        onTap: () async {
                                          setUpdate(item);
                                          Navigator.of(context).pop();
                                        },
                                        title: const Text('Edit Todo'),
                                        trailing: const Icon(
                                          Icons.edit_rounded,
                                          color: Colors.green,
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () async {
                                          setDelete(item);
                                          Navigator.of(context).pop();
                                        },
                                        leading: const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                        ),
                                        title: const Text(
                                          'Delete Todo',
                                          textAlign: TextAlign.center,
                                        ),
                                        trailing: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          title: Text(item.title),
                          subtitle: Text(item.description),
                          trailing: Checkbox(
                            value: item.completed,
                            onChanged: (value) async {
                              var newTodo = item;
                              newTodo.completed = value ?? false;
                              await update(newTodo);
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget updateView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: todoForm,
          ),
        ],
      ),
    );
  }

  @override
  Widget deleteView(BuildContext context) {
    if (itemToEdit != null) {
      delete(itemToEdit!);
    }
    setRead();
    return readView(context);
  }
}
