import 'package:flutter/material.dart';
import 'package:sqflite_test/dbhelper.dart';

class showList extends StatefulWidget {
  @override
  State<showList> createState() => _showListState();
}

class _showListState extends State<showList> {
  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Read Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: dbHelper.getAllRows(),
        builder: (context, snapshot) {
          print("hasData : ${snapshot.hasData}");
          print("hasData : ${snapshot.data?.length}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {

            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Data Found!!"),
              );
            }
            List<Map<String, dynamic>> dataList = snapshot.data as List<Map<String, dynamic>>;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = dataList[index];

                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Icon(Icons.delete_forever),
                      ),
                      key: UniqueKey(),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => {},
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 12.0, 12.0, 6.0),
                                      child: Text(
                                        data[DbHelper.columnName].toString(),
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 6.0, 12.0, 12.0),
                                      child: Text(
                                        data[DbHelper.columnAge].toString(),
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              height: 2.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      onDismissed: (direction) async {
                        var id = await dbHelper.delete(
                            int.parse(data[DbHelper.columnId].toString()));
                        if (id> 0) {
                          setState(() {
                            dataList = List.from(dataList)..removeAt(index);
                          });
                        }
                      },
                    );

                    return Container(
                      child: Text(snapshot.data!.last.values.toString()),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
