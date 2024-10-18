import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/model/note.dart';
import 'package:flutter_application_1/src/services/localDBServices.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({super.key, this.note});
  
  final Note? note;

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    final desc = _descriptionController.text;

    if (widget.note != null) {
      if (title.isEmpty && desc.isEmpty) {
        LocalDBService().deleteNote(id: widget.note!.id!, context: context);
      } else if (widget.note!.title != title || widget.note!.description != desc) {
        final updatedNote = widget.note!.copyWith(
          title: title,
          description: desc,
          lastMod: DateTime.now(),
        );
        LocalDBService().saveNote(note: updatedNote);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note updated!')));
      }
    } else {
      final newNote = Note(
        id: null,
        title: title,
        description: desc,
        lastMod: DateTime.now(),
      );
      LocalDBService().saveNote(note: newNote);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note saved!')));
    }
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'Create Note', style: GoogleFonts.poppins(fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Title"),
                style: GoogleFonts.poppins(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
                style: GoogleFonts.poppins(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}