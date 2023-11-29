import 'package:flutter/material.dart';
import 'package:note_blocks/add_a_note.dart';
import 'package:note_blocks/db_helper.dart';
import 'package:note_blocks/note_details2.dart';
import 'package:note_blocks/left_overs/drawer.dart';

class Home3 extends StatefulWidget {
  @override
  State<Home3> createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
//Get All Datas From Database
  void _refreshData() async {
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

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        //drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.grey[300]),
              centerTitle: true,
              title: Text(
                'N O T E  B L O C K S',
                style: TextStyle(color: Colors.grey[300]),
              ),
              backgroundColor: Colors.black,
              expandedHeight: 300.0,
              floating: false,
              pinned: false,
              //leading: Icon(Icons.menu),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.transparent, // Kırmızı arka plan rengi
                ),
                //title:Text('N O T E  B L O C K S'),
                centerTitle: true,
              ),
            ),
            /*SliverToBoxAdapter(
              child: SizedBox(
                height: 70, // Container yüksekliği
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (index) {
                    return Container(
                      width: 70, // Container genişliği
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      //color: Colors.blue, bu ne bilmiyorum
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.folder,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),*/
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(
                  _allData.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteDetails2(noteId: _allData[index]['id']),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    _allData[index]["content"],
                                    style: TextStyle(color: Colors.grey[300]),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                _allData[index]["title"],
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                _allData[index]["createdAt"].split(" ")[0],
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => (Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.my_library_add_outlined,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
