import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_data/services/hive_service.dart';
import 'package:persistent_data/services/utils.dart';
import 'package:persistent_data/ui/widgets/add_category_bottom_sheet.dart';
import 'package:persistent_data/ui/widgets/are_you_sure_dialog.dart';

import 'category_entries_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Box<String>? categoriesBox;

  @override
  void initState() {
    super.initState();
    HiveService.getCategoriesBox().then(
      (value) => setState(
        () => categoriesBox = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: categoriesBox == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ValueListenableBuilder(
              valueListenable: categoriesBox!.listenable(),
              builder: (context, Box<String> box, widget) =>
                  categoriesList(box),
            ),
      floatingActionButton: categoriesBox == null
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: _addCategory,
              child: const Icon(
                Icons.add,
              ),
            ),
    );
  }

  Widget categoriesList(Box<String> box) {
    return ListView.builder(
      itemCount: box.values.length,
      itemBuilder: (context, index) {
        if (box.isEmpty) return const SizedBox.shrink();
        final category = box.values.elementAt(index);
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecordsPage(category: category),
            ),
          ),
          child: ListTile(
            title: Text(category),
            trailing: IconButton(
              onPressed: () => _deleteCategory(category),
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }

  void _addCategory() {
    Utils.openBottomSheet(
      context,
      AddCategoryBottomSheet(
        addCategory: (String category) async {
          if (!categoriesBox!.containsKey(category)) {
            await categoriesBox?.put(category, category);
          }
        },
      ),
    );
  }

  void _deleteCategory(String category) async {
    final result = await Utils.openDialog(
      context,
      AreYouSureDialog(message: "Would you like to remove $category category?"),
    );
    if (result != null) categoriesBox?.delete(category);
  }
}
