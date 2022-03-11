import 'package:flutter/material.dart';

import 'package:persistent_data/models/record.dart';

class AddRecordBottomSheet extends StatelessWidget {
  AddRecordBottomSheet({
    Key? key,
    required this.addRecord,
  }) : super(key: key);

  final void Function(Record record) addRecord;

  final TextEditingController _nameTextFieldController =
      TextEditingController();
  final TextEditingController _descriptionTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Add record',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameTextFieldController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10.0,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => _nameTextFieldController.text = '',
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _descriptionTextFieldController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Description',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10.0,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => _descriptionTextFieldController.text = '',
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () {
              addRecord(Record(
                name: _nameTextFieldController.text,
                description: _descriptionTextFieldController.text,
              ));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
