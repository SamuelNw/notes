import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:notes/constants/routes.dart";
import "package:notes/enums/menu_action.dart";
import "package:notes/services/auth/auth_service.dart";
import "package:notes/services/auth/bloc/auth_bloc.dart";
import "package:notes/services/auth/bloc/auth_event.dart";
import "package:notes/services/cloud/cloud_note.dart";
import "package:notes/services/cloud/firebase_cloud_storage.dart";
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
      appBar: AppBar(
        title: const Text("Your Notes"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                )
              ];
            },
          )
        ],
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
            side: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          child: const Icon(
            Icons.add_sharp,
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
