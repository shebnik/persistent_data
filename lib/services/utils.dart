import 'package:flutter/material.dart';

class Utils {
  static openBottomSheet(BuildContext context, Widget bottomSheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: bottomSheet,
      ),
    );
  }

  static Future<bool?> openDialog(BuildContext context, Widget dialog) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}