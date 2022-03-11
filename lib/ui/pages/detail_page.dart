import 'package:flutter/material.dart';

import 'package:persistent_data/models/record.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key? key,
    required this.record,
  }) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.name,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 16),
            Text(
              record.description,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
