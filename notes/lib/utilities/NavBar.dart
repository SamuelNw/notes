// ignore_for_file: file_names

import "package:flutter/material.dart";

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
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notes, color: tileColor),
                  title: Text(
                    "All Notes",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                ListTile(
                  leading: Icon(Icons.note_add, color: tileColor),
                  title: Text(
                    "Create New Note",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: tileColor),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
                ListTile(
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
                  leading: Icon(Icons.logout_outlined, color: tileColor),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  titleTextStyle: TextStyle(color: tileColor),
                ),
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
