import 'package:flutter/material.dart';
import 'package:flutter_sqlite_project/database/sqlite_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _dataList = [];

  getAllData() async {
    var List = await SQLHelper.getAllData();
    setState(() {
      _dataList = List;
    });
  }

  addItems(int? id, String? title, String? description) {
    TextEditingController titleController = TextEditingController();
    TextEditingController desController = TextEditingController();

    if (id != null) {
      titleController.text = title!;
      desController.text = description!;
    }

    return showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: 1500,
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    TextField(
                      controller: desController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var title = titleController.text.toString();
                        var des = desController.text.toString();
                        if (id == null) {
                          SQLHelper.insertData(title, des).then((value) => {
                                if (value != -1)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Data inserted Successfully")),
                                    ),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("failed to insert")),
                                    ),
                                  }
                              });
                        } else {
                          SQLHelper.updateData(id, title, des);
                        }
                        Navigator.of(context).pop(context);
                        getAllData();
                      },
                      child: id == null
                          ? Text("Insert Data")
                          : Text("Update Data"),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NotePad"),
      ),
      body: _dataList.isNotEmpty
          ? ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, position) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(_dataList[position]["title"].toString()),
                    subtitle:
                        Text(_dataList[position]["description"].toString()),
                    trailing: Wrap(
                      spacing: 20,
                      children: [
                        GestureDetector(
                          onTap: () {
                            addItems(
                                _dataList[position]["id"],
                                _dataList[position]["title"].toString(),
                                _dataList[position]["description"].toString());
                          },
                          child: Icon(Icons.edit),
                        ),
                        GestureDetector(
                          onTap: () {
                            SQLHelper.deleteData(_dataList[position]["id"]);
                            getAllData();
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("NO Data Found"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItems(null, null, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
