import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class Record extends HiveObject {
  
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String description;

  Record({
    required this.name,
    required this.description,
  });
}
