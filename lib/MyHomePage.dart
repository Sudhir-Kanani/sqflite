import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_test/dbhelper.dart';
import 'package:sqflite_test/showList.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DbHelper  dbHelper= DbHelper();

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  String? nameErrorText;

  bool _validate = false;
  bool _validateAge = false;

  @override
  void initState() {
    dbHelper.init();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> insertData() async {
    if (nameController.text.isEmpty) {
      setState(() {
        _validate = true;
      });
      return;
    }

    if (ageController.text.isEmpty) {
      setState(() {
        _validateAge = true;
      });
      return;
    }

    Map<String, dynamic> row = {
      DbHelper.columnName: nameController.text,
      DbHelper.columnAge: ageController.text
    };

    final id = await dbHelper.insertData(row);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Insert Successfully !!")));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sqflite", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Enter Name",
                  errorText: _validate ? "Value Can't Be Empty" : null,
                ),
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? _validate = true : _validate = false;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Enter Age",
                  errorText: _validateAge ? "Value Can't Be Empty" : null,
                ),
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? _validateAge = true : _validateAge = false;
                  });
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: () {
                  insertData();

                  // insertData();
                },
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
                child: const Text("Insert"),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => showList()));
                },
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
                child: Text("Read"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
