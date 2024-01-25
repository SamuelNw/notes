import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:notes/constants/routes.dart";
import "package:notes/services/auth/auth_service.dart";
import "package:notes/services/auth/bloc/auth_bloc.dart";
import "package:notes/services/auth/bloc/auth_event.dart";
import "package:notes/services/cloud/cloud_note.dart";
import "package:notes/services/cloud/firebase_cloud_storage.dart";
import 'package:notes/utilities/NavBar.dart';
import "package:notes/utilities/dialogs/logout_dialog.dart";
import "package:notes/views/notes/notes_list_view.dart";
import "package:notes/views/temp_loading_page.dart";

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 22, 24),
      drawer: const Drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 42, 46),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu),
                  );
                }),
                const SizedBox(width: 12),
                const Expanded(
                  child: CupertinoTextField(
                    placeholder: "Search your notes",
                    placeholderStyle: TextStyle(
                      color: Color.fromARGB(255, 207, 207, 207),
                      fontFamily: "Jost",
                      fontSize: 16.0,
                    ),
                    cursorColor: Colors.white,
                    decoration: BoxDecoration(color: Colors.transparent),
                    style: TextStyle(
                      color: Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(const AuthEventLogout());
                    }
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 207, 207, 207),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox.fromSize(
        size: const Size.fromRadius(36.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
          },
          backgroundColor: const Color.fromARGB(255, 0, 42, 46),
          foregroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: const BorderSide(
              color: Color.fromARGB(255, 207, 207, 207),
              width: 1.0,
            ),
          ),
          child: const Icon(
            Icons.add_sharp,
            color: Color.fromARGB(255, 207, 207, 207),
            size: 40.0,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _noteService.deleteNote(
                        documentId: note.documentId,
                      );
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    });
              } else {
                return const TempLoadingPage();
              }
            default:
              return const TempLoadingPage();
          }
        },
      ),
    );
  }
}
