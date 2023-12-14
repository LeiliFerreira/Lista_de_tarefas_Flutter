import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  bool completed;
  Task(this.title, {this.completed = false});
}

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (int i = 0; i < strengths.length; i++) {
    double ds = strengths[i];
    swatch[(ds * 1000).round()] = Color.fromRGBO(r, g, b, ds);
  }

  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor customColor = _createMaterialColor(Color(0xFF03BB85));
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: customColor,
        appBarTheme: AppBarTheme(),
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Color(0xFF03BB85),
      ),
      body: Stack(
        children: [
          // Elementos da lista
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Checkbox(
                      value: tasks[index].completed,
                      onChanged: (value) {
                        _toggleTaskCompletion(index);
                      },
                    ),
                    Flexible(
                      child: Text(
                        tasks[index].title,
                        style: TextStyle(
                          decoration: tasks[index].completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _openTaskDetails(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteTaskDialog(index);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _openTaskDetails(index);
                },
              );
            },
          ),

          Center(
            child: Image.asset(
              'images/icone_notas.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF03BB85),
      ),
    );
  }

  void _addTask() async {
    String newTaskTitle = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String value = '';
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            onChanged: (newValue) {
              value = newValue;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(value);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (newTaskTitle != null && newTaskTitle.isNotEmpty) {
      setState(() {
        tasks.add(Task(newTaskTitle));
      });
    }
  }

  void _openTaskDetails(int index) async {
    Task selectedTask = tasks[index];

    String updatedTitle = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String value = '';
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            controller: TextEditingController(text: selectedTask.title),
            onChanged: (newValue) {
              value = newValue;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(value);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (updatedTitle != null && updatedTitle.isNotEmpty) {
      setState(() {
        selectedTask.title = updatedTitle;
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
  }

  void _showDeleteTaskDialog(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Tarefa'),
          content: Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        tasks.removeAt(index);
      });
    }
  }
}
