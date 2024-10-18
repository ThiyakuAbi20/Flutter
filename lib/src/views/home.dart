import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/model/note.dart';
import 'package:flutter_application_1/src/services/localDBServices.dart';
import 'package:flutter_application_1/src/views/create_note.dart';
import 'package:flutter_application_1/src/views/widgets/empty_views.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Notes", style: GoogleFonts.poppins(fontSize: 24)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isListView = !isListView;
                      });
                    },
                    icon: Icon(isListView ? Icons.splitscreen_outlined : Icons.grid_view),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Note>>(
              stream: LocalDBService().listenAllNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final notes = snapshot.data;

                if (notes == null || notes.isEmpty) {
                  return const Expanded(child: EmptyViews());
                }

                return Expanded(
                  child: isListView
                      ? ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return ListTile(
                              title: Text(note.title, style: GoogleFonts.poppins(fontSize: 18)),
                              subtitle: Text(note.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                              onTap: () async {
                                // Navigate to edit note
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNoteView(note: note)));
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Call deleteNote with the context
                                  await LocalDBService().deleteNote(id: note.id!, context: context);
                                },
                              ),
                            );
                          },
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return GestureDetector(
                              onTap: () async {
                                // Navigate to edit note
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNoteView(note: note)));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(note.title, style: GoogleFonts.poppins(fontSize: 18)),
                                      const SizedBox(height: 10),
                                      Text(note.description, maxLines: 3, overflow: TextOverflow.ellipsis),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await LocalDBService().deleteNote(id: note.id!, context: context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create note view
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateNoteView()));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color.fromARGB(255, 135, 230, 40)),
      ),
    );
  }
}