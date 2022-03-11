import 'package:flutter/material.dart';

class AddCategoryBottomSheet extends StatelessWidget {
  AddCategoryBottomSheet({
    Key? key,
    required this.addCategory,
  }) : super(key: key);

  final void Function(String) addCategory;

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Add category',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _textFieldController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Category name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10.0,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => _textFieldController.text = '',
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () {
              addCategory(_textFieldController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
