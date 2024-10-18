import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/model/note.dart';
import 'package:flutter_application_1/src/views/widgets/note_list_item.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // Optionally, initialize the list animations here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.all(20),
      initialItemCount: widget.notes.length,
      itemBuilder: (context, index, animation) {
        final note = widget.notes[index];
        return SizeTransition(
          sizeFactor: animation, // Size transition animation
          child: NoteListItem(
            note: note,
          ),
        );
      },
    );
  }
}
