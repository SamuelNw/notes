import "package:flutter/material.dart";
import "package:notes/utilities/dialogs/generic_dialog.dart";

Future<void> showPasswordResetDialoog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content: "We have sent you a password reset link. For more information, check your email.",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
