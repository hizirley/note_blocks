import 'package:flutter/material.dart';
import 'package:note_blocks/attempt3.dart';
import 'package:note_blocks/db_helper.dart';

class AddNotePage extends StatelessWidget {
  @override

  //Add Data
  Future<void> _addData() async {
    await SQHelper.createData(_titleController.text, _contentController.text);
    //_refreshData();
    _titleController.text = "";
    _contentController.text = "";
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[300]),
        backgroundColor: Colors.transparent,
        title: Text(
          'A D D  A  N E W  N O T E',
          style: TextStyle(color: Colors.grey[300]),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_titleController.text != "" || _contentController.text != "") {
              _addData();
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Home3()), // Burada BelirtilenSayfa yerine gidilmek istenen sayfanın sınıfı belirtilmeli
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: TextStyle(
                  color: Colors.grey[300], // Girdi rengi burada belirlenir
                ),
                controller: _titleController,
                decoration: InputDecoration(
                    fillColor: Colors.grey[900],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "T I T L E:",
                    hintStyle: TextStyle(color: Colors.grey[300])),
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(
                  color: Colors.grey[300], // Girdi rengi burada belirlenir
                ),
                controller: _contentController,
                maxLines: 30,
                decoration: InputDecoration(
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "C O N T E N T:",
                    hintStyle: TextStyle(color: Colors.grey[300])),
              ),
              SizedBox(height: 16.0),
              /*Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("ADD data"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[900], // Butonun arka plan rengi
                    onPrimary: Colors.grey[300], // Butonun üzerindeki yazı rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          16), // Yay şeklinde kenarlıklar için
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
