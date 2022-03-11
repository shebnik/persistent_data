import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_data/models/record.dart';
import 'package:persistent_data/services/hive_service.dart';
import 'package:persistent_data/services/utils.dart';
import 'package:persistent_data/ui/pages/detail_page.dart';
import 'package:persistent_data/ui/widgets/add_record_bottom_sheet.dart';
import 'package:persistent_data/ui/widgets/are_you_sure_dialog.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late final String category;
  Box<Record>? recordsBox;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    HiveService.getEntriesBox(category).then(
      (value) => setState(
        () => recordsBox = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: recordsBox == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ValueListenableBuilder(
              valueListenable: recordsBox!.listenable(),
              builder: (context, Box<Record> box, widget) => entryList(box),
            ),
      floatingActionButton: recordsBox == null
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: _addRecord,
              child: const Icon(
                Icons.add,
              ),
            ),
    );
  }

  Widget entryList(Box<Record> box) {
    return ListView.builder(
      itemCount: box.values.length,
      itemBuilder: (context, index) {
        if (box.isEmpty) return const SizedBox.shrink();
        final record = box.values.elementAt(index);
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailPage(record: record),
            ),
          ),
          child: ListTile(
            title: Text(record.name),
            trailing: IconButton(
              onPressed: () => _deleteRecord(record),
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }

  void _addRecord() {
    Utils.openBottomSheet(
      context,
      AddRecordBottomSheet(
        addRecord: (Record record) async {
          if (!recordsBox!.values.contains(record)) {
            await recordsBox?.add(record);
          }
        },
      ),
    );
  }

  void _deleteRecord(Record record) async {
    final result = await Utils.openDialog(
      context,
      AreYouSureDialog(
          message: "Would you like to remove ${record.name} record?"),
    );
    if (result != null) recordsBox?.delete(category);
  }
}
