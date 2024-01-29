import "package:flutter/material.dart";

class NoteItem extends StatelessWidget {
  final String noteTitle;
  final String noteBody;
  final String noteTag;
  final String createdAt;
  final String? noteImageLink;

  const NoteItem({
    super.key,
    required this.noteTitle,
    required this.noteBody,
    required this.noteTag,
    required this.createdAt,
    this.noteImageLink,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 115, 115, 115),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              noteImageLink != "None" && noteImageLink != null
                  ? Image.network(
                      noteImageLink!,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noteTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      noteBody,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 214, 214, 214),
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          noteTag,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 167, 167, 167),
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          createdAt,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 167, 167, 167),
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
