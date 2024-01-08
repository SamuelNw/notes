// import "package:flutter/foundation.dart";
// import "package:notes/extensions/lists/filter.dart";
// import "package:notes/services/crud/crud_exceptions.dart";
// import "package:sqflite/sqflite.dart";
// import "package:path_provider/path_provider.dart";
// import "package:path/path.dart" show join;
// import "dart:async";

// class NoteService {
//   Database? _db;

//   DatabaseUser? _user;

//   static final NoteService _shared = NoteService._sharedInstance();
//   NoteService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NoteService() => _shared;

//   // Work with streams:
//   List<DatabaseNote> _notes = [];

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           print("current user is empty.");
//           throw UserShouldBeSetBeforeFetchingAllNotesException();
//         }
//       });

//   // Get or Create a User:
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on UserNotFoundException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       if (e is UserAlreadyExistsException) {
//         final existingUser = await getUser(email: email);
//         _user = existingUser;
//         return existingUser;
//       } else {
//         rethrow;
//       }
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   // Update a particular note:
//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     await getNote(id: note.id);

//     final updateCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColoumn: 0,
//       },
//       where: "id = ?",
//       whereArgs: [
//         note.id
//       ],
//     );

//     if (updateCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   // Fetch all notes:
//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(noteTable);

//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   // Fetch particular note:
//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       noteTable,
//       limit: 1,
//       where: "id = ?",
//       whereArgs: [
//         id
//       ],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNote.fromRow(results.first);
//       _notes.removeWhere((note) => note.id == note);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   // Delete all notes:
//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final int numberOfDeletions = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   // Delete a note:
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: "id = ?",
//       whereArgs: [
//         id
//       ],
//     );

//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   // Create a note:
//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw UserNotFoundException();
//     }

//     const String text = "";
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColoumn: 1,
//     });

//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );

//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   // Obtain a user:
//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [
//         email.toLowerCase()
//       ],
//     );
//     if (results.isEmpty) {
//       throw UserNotFoundException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   // Create users on the table:
//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [
//         email.toLowerCase()
//       ],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(id: userId, email: email);
//   }

//   // Delete a user from the table:
//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final int deletedCount = await db.delete(
//       userTable,
//       where: "email = ?",
//       whereArgs: [
//         email.toLowerCase()
//       ],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   // Internal function to get db or throw error:
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   // Close db:
//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   // Ensure db is open:
//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty.
//     }
//   }

//   // Open the database:
//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       // Create user table:
//       await db.execute(createUserTable);

//       // Create the note table:
//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectoryException();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => "Person ID = $id, email = $email";

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// @immutable
// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud = (map[isSyncedWithCloudColoumn] as int) == 1 ? true : false;

//   @override
//   String toString() => "Note ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud,";

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = "notes.db";
// const noteTable = "note";
// const userTable = "user";

// const idColumn = "id";
// const emailColumn = "email";
// const userIdColumn = "user_id";
// const textColumn = "text";
// const isSyncedWithCloudColoumn = "is_synced_with_cloud";

// const createUserTable = '''
//         CREATE TABLE IF NOT EXISTS "user" (
//           "id"	INTEGER NOT NULL UNIQUE,
//           "email"	TEXT NOT NULL UNIQUE,
//           PRIMARY KEY("id" AUTOINCREMENT)
//         );
//       ''';

// const createNoteTable = '''
//         CREATE TABLE IF NOT EXISTS "note" (
//           "id"	INTEGER NOT NULL UNIQUE,
//           "user_id"	INTEGER NOT NULL,
//           "text"	TEXT NOT NULL,
//           "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//           FOREIGN KEY("user_id") REFERENCES "user"("id"),
//           PRIMARY KEY("id" AUTOINCREMENT)
//         );
//       ''';
