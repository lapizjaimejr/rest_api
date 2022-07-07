import 'package:flutter/material.dart';

class NoteModify extends StatelessWidget {
  final String? noteID;
  bool get isEditing => noteID != null;

  const NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!isEditing ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Note Title'),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
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
