// ignore_for_file: file_names

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:notes/services/auth/bloc/auth_bloc.dart";
import "package:notes/services/auth/bloc/auth_event.dart";
import "package:notes/utilities/dialogs/logout_dialog.dart";

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    const String avatar = "http://tinyurl.com/2cvt6bs3";
    const String accountBg = "http://tinyurl.com/45jpzx62";
    const Color tileColor = Color.fromARGB(255, 207, 207, 207);

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 0, 42, 46),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: const Text("johndoe@email.com"),
            accountName: const Text("John Doe"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  avatar,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: NetworkImage(accountBg),
                fit: BoxFit.fitHeight,
              ),
              border: Border(bottom: BorderSide.none),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              "Notes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notes, color: Colors.white),
                  selected: true,
                  selectedColor: Colors.white,
                  selectedTileColor: const Color.fromARGB(255, 0, 74, 81),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  title: const Text(
                    "All Notes",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: const TextStyle(color: tileColor),
                ),
                const ListTile(
                  leading: Icon(Icons.note_add, color: tileColor),
                  title: Text(
                    "Create New Note",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                const ListTile(
                  leading: Icon(Icons.settings, color: tileColor),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                const ListTile(
                  leading: Icon(Icons.help_outline_rounded, color: tileColor),
                  title: Text(
                    "Help and Feedback",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                ListTile(
                    leading: const Icon(Icons.logout_outlined, color: tileColor),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    titleTextStyle: const TextStyle(color: tileColor),
                    focusColor: const Color.fromARGB(255, 0, 74, 81),
                    onTap: () async {
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        // ignore: use_build_context_synchronously
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 320),
          const Center(
            child: Text(
              "Copyright@NotesWorld",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
