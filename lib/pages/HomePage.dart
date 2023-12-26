import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/util/dialog_box.dart';
import 'package:to_do_list/util/todo_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState(); //In Flutter, the createState() method is a required method that you must override when creating a stateful widget.
                                                    // This method is responsible for creating the mutable state associated with an instance of the stateful widget.
                                                    // The createState() method returns an instance of the state class, which must be a subclass of State and is responsible for managing the widget's mutable state.
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box('mybox');
  toDoDatabase db = toDoDatabase();

  @override
  void initState() {
    if(_mybox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  final _controller = TextEditingController(); //TextEditingController is a class in Flutter that is used to control a text field.
                                              // It allows you to manipulate and interact with the text input in a text field.
                                              // This class provides methods and properties that enable you to read, modify, and listen to changes in the text entered by the user.

  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1]; //tick untick
    });
    db.updateDataBase();
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop(); //it is used to dismiss a dialog or screen.
                                //context is an object that provides information about the location of the widget in the widget tree and holds references to various services and resources.
    db.updateDataBase();
  }

  void createNewTask(){
    showDialog(context: context,
        builder: (context){
          return DialogBox(controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text('TO DO'),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return ToDoTile(taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value,index),
              deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}