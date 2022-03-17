import 'dart:typed_data';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Uint8List? imageBytes;

  const Avatar({
    Key? key,
    required this.imageBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      child: imageBytes != null
          ? ClipOval(
              child: Image.memory(
                imageBytes!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }
}
