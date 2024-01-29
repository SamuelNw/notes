import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class EmptyNotesView extends StatelessWidget {
  const EmptyNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("assets/other/no_notes.png"),
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              "Unleash your inner author. The first sentence awaits.",
              style: GoogleFonts.jost(
                color: Colors.white,
                fontSize: 21.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
