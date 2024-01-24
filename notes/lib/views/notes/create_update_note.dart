import "package:flutter/material.dart";
import "package:notes/services/auth/auth_service.dart";
import "package:notes/services/cloud/cloud_note.dart";
import "package:notes/services/cloud/firebase_cloud_storage.dart";
import "package:notes/utilities/generics/get_arguments.dart";
import "package:notes/utilities/dialogs/sharing_dialog.dart";
import "package:notes/views/temp_loading_page.dart";

import "package:share_plus/share_plus.dart";
import "package:intl/intl.dart";

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({super.key});

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  // Current time:
  String formattedTime = DateFormat("h:mm a").format(DateTime.now());

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  Future<CloudNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _noteService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _titleControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setUpTitleControllerListener() {
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  void _deleteNoteIfEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null && _titleController.text.isEmpty) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;
    if (note != null && text.isNotEmpty && title.isNotEmpty) {
      await _noteService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 37, 41),
      // backgroundColor: const Color.fromARGB(255, 0, 22, 24), // A darker one.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(
              Icons.share,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            iconSize: 30,
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpTextControllerListener();
              _setUpTitleControllerListener();
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 26.0,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusColor: Colors.white,
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Type your note here...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusColor: Colors.white,
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_camera,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_library,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Edited at $formattedTime",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return const TempLoadingPage();
          }
        },
      ),
    );
  }
}
