import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_data/ui/widgets/footer_widget.dart';
import 'package:http/http.dart' show get;
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String imagesPath;
  List<File>? images;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    imagesPath = p.join(appDocDir.path, "images");
    final imagesDir = await Directory(imagesPath).create(recursive: true);
    images = await imagesDir.list().map((event) => File(event.path)).toList();
    setState(() {});
  }

  Future<void> _saveImage(String url) async {
    final imageName = url.substring(url.lastIndexOf("/") + 1);
    final response = await get(Uri.parse(url));
    File image = File(p.join(imagesPath, imageName));
    await image.writeAsBytes(response.bodyBytes);
    setState(() {
      images?.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: images == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : imageList(),
            ),
          ),
          FooterWidget(saveImage: _saveImage),
        ],
      ),
    );
  }

  Widget imageList() {
    if (images!.isEmpty) return noSavedImages();
    return ListView.separated(
      itemCount: images!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final image = images![index];
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget noSavedImages() {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.image),
          SizedBox(height: 8),
          Text('No saved images'),
        ],
      ),
    );
  }
}
