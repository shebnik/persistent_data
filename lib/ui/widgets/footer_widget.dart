import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  FooterWidget({
    Key? key,
    required this.saveImage,
  }) : super(key: key);

  final _textFieldController = TextEditingController();
  final void Function(String) saveImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(color: Colors.black, height: 0.5),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => _textFieldController.text = '',
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    saveImage(_textFieldController.text);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
