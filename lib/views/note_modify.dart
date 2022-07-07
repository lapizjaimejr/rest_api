import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/services/notes_service.dart';

import '../models/note.dart';

class NoteModify extends StatefulWidget {
  final String? noteID;
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  NotesService get notesService => GetIt.I<NotesService>();
  bool get isEditing => widget.noteID != null;
  bool _isLoading = false;
  late String errorMessage;
  late Note note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    notesService.getNote(widget.noteID!).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.error!) {
        errorMessage = response.errorMessage ?? 'An error occured';
      }
      note = response.data!;
      _titleController.text = note.noteTitle!;
      _contentController.text = note.noteContent!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!isEditing ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note Title'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Note Content'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            //update
                          } else {
                            //create
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        )),
                  ),
                ],
              ),
      ),
    );
  }
}
