import "package:flutter/material.dart";
import "package:notes/utilities/dialogs/generic_dialog.dart";

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "Cannot share an empty Note!",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
