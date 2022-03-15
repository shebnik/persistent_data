import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  IntColumn get age => integer()();
  TextColumn get avatar => text()();
  IntColumn get phoneNumber => integer()();
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<User>> get allUsers => select(users).get();
  Future<int> addUser(user) => into(users).insert(user);

  Stream<User> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).watchSingle();

  Future<bool> updateUser(User user) => update(users).replace(user);
  Future<int> removeUser(User user) =>
      (delete(users)..where((u) => u.id.equals(user.id))).go();

  Stream<List<User>> get usersStream => select(users).watch();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
