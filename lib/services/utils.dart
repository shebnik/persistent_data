import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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

  static Future<Uint8List?> chooseAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp'],
    );

    if (result != null) {
      String? path = result.files.single.path;
      if (path == null) return null;
      return await File(path).readAsBytes();
    }
    return null;
  }
}