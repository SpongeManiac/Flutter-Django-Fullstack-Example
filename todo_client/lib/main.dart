import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_client/API.dart';
import 'package:todo_client/CRUDPage.dart';

import 'BasePage.dart';
import 'Todo.dart';
import 'hideableFloatingAction.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends BasePage {
  MyHomePage({super.key, required super.title});

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
  ValueNotifier<HideableFloatingActionData> floatingActionNotifier =
      new ValueNotifier(HideableFloatingActionData(false));

  TextEditingController titleField = TextEditingController();
  TextEditingController descriptionField = TextEditingController();
  bool completed = false;

  void _createTodo() {}

  Future<List<Todo>> getTodos() async {
    return await TodoAPI.getTodos();
  }

  @override
  void initState() {
    floatingActionNotifier.value = HideableFloatingActionData(
      true,
      () async {
        await setCreate();
      },
      Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
    );
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
      floatingActionButton: HideableFloatingAction(
          floatingActionNotifier:
              floatingActionNotifier), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  Future<void> setRead() async {
    floatingActionNotifier.value = HideableFloatingActionData(
      true,
      () async {
        await setCreate();
      },
      Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
    );
    titleField.text = '';
    descriptionField.text = '';
    completed = false;
    itemToEdit = null;
    await super.setRead();
  }

  @override
  Future<void> setCreate() async {
    floatingActionNotifier.value = HideableFloatingActionData(false);
    titleField.text = '';
    descriptionField.text = '';
    completed = false;
    await super.setCreate();
  }

  @override
  Future<void> setUpdate(Todo todo) async {
    itemToEdit = todo;
    floatingActionNotifier.value = HideableFloatingActionData(
      true,
      () async {
        await setRead();
      },
      Icon(
        Icons.arrow_back_rounded,
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
    print('creating');
    return Todo('', '', false);
  }

  @override
  Widget createView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Title'),
                  subtitle: TextFormField(
                    controller: titleField,
                  ),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: TextFormField(
                    controller: descriptionField,
                  ),
                ),
                CheckboxListTile(
                  title: Text('Completed'),
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
          Row(
            children: [],
          ),
        ],
      ),
    );
  }

  @override
  Future<void> delete(Todo item) async {
    await TodoAPI.delTodo(item);
    setState(() {});
  }

  @override
  Widget deleteView(BuildContext context) {
    if (itemToEdit != null) {
      delete(itemToEdit!);
    }
    setRead();
    return readView(context);
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
                print('got list: $list');
                return RefreshIndicator(
                  onRefresh: () async {},
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
                        print('Item ${item.id}: ${item.title}');
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
                                    title: Text('Todo Options'),
                                    actions: [
                                      ListTile(
                                        onTap: () async {
                                          setUpdate(item);
                                          Navigator.of(context).pop();
                                        },
                                        title: Text('Edit Todo'),
                                        trailing: Icon(
                                          Icons.edit_rounded,
                                          color: Colors.green,
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () async {
                                          setDelete(item);
                                          Navigator.of(context).pop();
                                        },
                                        leading: Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                        ),
                                        title: Text(
                                          'Delete Todo',
                                          textAlign: TextAlign.center,
                                        ),
                                        trailing: Icon(
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
                              await TodoAPI.updateTodo(newTodo);
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
  Future<Todo> update(Todo item) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Widget updateView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Title'),
                  subtitle: TextFormField(
                    controller: titleField,
                  ),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: TextFormField(
                    controller: descriptionField,
                  ),
                ),
                CheckboxListTile(
                  title: Text('Completed'),
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
        ],
      ),
    );
  }
}
