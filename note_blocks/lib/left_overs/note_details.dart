import 'package:flutter/material.dart';
import 'package:note_blocks/left_overs/attempt.dart';
import 'package:note_blocks/db_helper.dart';

class NoteDetails extends StatefulWidget {
  final int noteId; // Notun ID'si

  const NoteDetails({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNoteDetails();
  }

  Future<void> _fetchNoteDetails() async {
    try {
      final noteDetails = await SQHelper.getSingleData(widget.noteId);

      if (noteDetails.isNotEmpty) {
        setState(() {
          _titleController.text = noteDetails.first['title'];
          _contentController.text = noteDetails.first['content'];
          _isLoading = false;
        });
      } else {
        print('Note not found with ID: ${widget.noteId}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching note details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateNote() async {
    try {
      await SQHelper.updateData(
        widget.noteId,
        _titleController.text,
        _contentController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      print('Note updated successfully!');
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Future<void> _deleteNote() async {
    try {
      await SQHelper.deleteData(widget.noteId);
      print('Note deleted successfully!');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _updateNote();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Bu satır geri oku kaldırır

          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.grey[300],),
                onPressed: () async {
                  try {
                    await SQHelper.updateData(
                      widget.noteId,
                      _titleController.text,
                      _contentController.text,
                    );
                    print('Note updated successfully!');
                  } catch (e) {
                    print('Error updating note: $e');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              Spacer(),
              Text('N O T E  D E T A I L '),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete,color: Colors.grey[300],),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete Note"),
                        content:
                            Text("Are you sure you want to delete this note?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Delete"),
                            onPressed: () {
                              _deleteNote();
                              Navigator.of(context).pop(); // Geri git
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          centerTitle: true,
          actions: [],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'TITLE:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey[300]),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      onChanged: (value) {
                        setState(() {
                          _titleController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                      style: TextStyle(fontSize: 16,color: Colors.grey[300]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'C O N T E N T:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey[300]),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      
                      controller: _contentController,
                      onChanged: (value) {
                        setState(() {
                          _contentController.text = value;
                        });
                      },
                      maxLines: MediaQuery.of(context).size.height ~/ 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                      style: TextStyle(fontSize: 16,color: Colors.grey[300]),
                    ),
                  ],
                ),
              )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
