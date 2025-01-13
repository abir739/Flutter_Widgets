import 'package:flutter/material.dart';
import 'package:flutter_sql_database/db/notes_db.dart';
import 'package:flutter_sql_database/model/note_model.dart';
import 'package:flutter_sql_database/screens/add_note_screen.dart';
import 'package:flutter_sql_database/screens/edit_note_screen.dart';
import 'package:flutter_sql_database/widget/note_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<NoteModel> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshScreen();
  }

  Future refreshScreen() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    NotesDatabase.instance.dbClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Notes List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text('No Notes yet!')
                : buildNotesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNotesList() => StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: List.generate(notes.length, (index) {
          final note = notes[index];
          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () => editNote(note),
              child: NoteCardWidget(note: note, index: index),
            ),
          );
        }),
      );

  Future<void> addNote() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddNoteScreen(),
    ));
    refreshScreen();
  }

  Future<void> editNote(NoteModel note) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditNoteScreen(note: note),
    ));
    refreshScreen();
  }
}
