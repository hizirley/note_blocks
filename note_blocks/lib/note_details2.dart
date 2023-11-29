import 'package:flutter/material.dart';
import 'package:note_blocks/attempt3.dart';
import 'package:note_blocks/db_helper.dart';

class NoteDetails2 extends StatefulWidget {
  final int noteId;

  const NoteDetails2({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetails2> createState() => _NoteDetails2State();
}

class _NoteDetails2State extends State<NoteDetails2> {
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
        MaterialPageRoute(builder: (context) => Home3()),
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
        MaterialPageRoute(builder: (context) => Home3()),
      );
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SQHelper.getSingleData(widget.noteId),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          final noteData = snapshot.data!.first;
          String title = noteData['title'] ?? '';
          String content = noteData['content'] ?? '';

          return Scaffold(backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Text('N O T E  D E T A I L',style: TextStyle(color: Colors.grey[300])),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[300],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: Text("Delete Note",style: TextStyle(color: Colors.grey[300]),),
                            content: Text(
                                "Are you sure you want to delete this note?",style: TextStyle(color: Colors.grey[300]),),
                            actions: [
                              TextButton(
                                child: Text("Cancel",style: TextStyle(color: Colors.grey[300]),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Delete",style: TextStyle(color: Colors.red[300]),),
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey[300],
                ),
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
                    MaterialPageRoute(builder: (context) => Home3()),
                  );
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SizedBox(height: 16,),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'T I T L E',
                        filled: true,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[
                              300], // labelText'in rengi burada belirlenebilir
                        ),
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _contentController,
                      maxLines: 30,
                      decoration: InputDecoration(
                        labelText: 'C O N T E N T',
                        filled: true,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[
                              300], // labelText'in rengi burada belirlenebilir
                        ),
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
