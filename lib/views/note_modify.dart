import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/services/notes_service.dart';

import '../models/note.dart';
import '../models/note_insert.dart';

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

    if (isEditing) {
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
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });

                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.updateNote(
                                widget.noteID!, note);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = 'Done';
                            final text = result.error!
                                ? (result.errorMessage ??
                                    'An error has occured')
                                : 'Your note was updated';

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ok'),
                                  )
                                ],
                              ),
                            ).then((data) {
                              if (result.data!) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.createNote(note);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = 'Done';
                            final text = result.error!
                                ? (result.errorMessage ??
                                    'An error has occured')
                                : 'Your note was created';

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ok'),
                                  )
                                ],
                              ),
                            ).then((data) {
                              if (result.data!) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
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
