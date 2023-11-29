import 'package:flutter/material.dart';
import 'package:note_blocks/db_helper.dart';
import 'package:note_blocks/left_overs/drawer.dart';
import 'package:note_blocks/left_overs/note_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

//Get All Datas From Database
  void _refreshData() async {
    print("_refreshData() called");
    final data = await SQHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

//Add Data
  Future<void> _addData() async {
    await SQHelper.createData(_titleController.text, _contentController.text);
    _refreshData();
  }

//Update Data
  Future<void> _updateData(int id) async {
    await SQHelper.updateData(
        id, _titleController.text, _contentController.text);
    _refreshData();
  }

//Delete Data
  void _deleteData(int id) async {
    await SQHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data Deleted"),
    ));
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void showBottomSheet(int? id) async {
    //if id is not null then it will update other wise it will add new data
    //when edit icon is pressed then id will be given to bottomsheet function and
    //it will edit
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element["id"] == id);
      _titleController.text = existingData["title"];
      _contentController.text = existingData["content"];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
          top: 60,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        decoration: BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    hintText: "T I T L E:",
                    hintStyle: TextStyle(color: Colors.grey[300])),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 30,
                decoration: InputDecoration(
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    hintText: "C O N T E N T:",
                    hintStyle: TextStyle(color: Colors.grey[300])),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[900], // Butonun arka plan rengi
                    onPrimary: Colors.grey[300], // Butonun üzerindeki yazı rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          16), // Yay şeklinde kenarlıklar için
                    ),
                  ),
                  onPressed: () async {
                    if (id == null) {
                      await _addData();
                    }
                    if (id != null) {
                      await _updateData(id);
                    }

                    _titleController.text = "";
                    _contentController.text = "";
                    //Hide BottomSheet
                    Navigator.of(context).pop();
                    print("D A T A  A D D E D");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      id == null ? "A D D  D A T A" : "Update Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: AppDrawer(),
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            //leading: Icon(Icons.menu),
            //title: Text("S L I  V E R A P P B A R"),
            expandedHeight: 300,
            floating: false, //bu cok onemli
            pinned: false, //bu da cok onemli
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.transparent,
              ),
              centerTitle: true,
              title: Text(
                "N O T E   B L O C K S",
                style: TextStyle(color: Colors.grey[300]),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0), // Ekran kenarlarına boşluk
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoteDetails(noteId: _allData[index]['id']),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding:
                          EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding:
                                  EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Text(
                                _allData[index]["content"],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[300]),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Column(
                            children: [
                              Text(
                                _allData[index]["title"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[300]),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                _allData[index]["createdAt"].split(" ")[0],
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: _allData.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => showBottomSheet(null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10), // Kare köşeler için bir yuvarlaklık seçebilirsiniz
        ),
        child: Icon(
          Icons.my_library_add_outlined,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
