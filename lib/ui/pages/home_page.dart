import 'package:flutter/material.dart';
import 'package:persistent_data/database/database.dart';
import 'package:persistent_data/services/utils.dart';
import 'package:persistent_data/ui/pages/user_detail.dart';
import 'package:persistent_data/ui/widgets/are_you_sure_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
  }

  Future<void> _addUser() async {
    await _database.addUser(
      UsersCompanion.insert(
        firstName: "firstName",
        lastName: "lastName",
        age: 18,
        avatar: "avatar",
        phoneNumber: 380993221444,
      ),
    );
  }

  Future<void> _updateUser(User user) async {
    await _database.updateUser(user);
  }

  Future<void> _removeUser(User user) async {
    final result = await Utils.openDialog(
      context,
      AreYouSureDialog(
          message:
              "Would you like to remove ${user.lastName} ${user.firstName} user?"),
    );
    if (result != null) await _database.removeUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder<List<User>>(
        initialData: const [],
        stream: _database.usersStream,
        builder: (context, users) {
          return ListView.builder(
            itemCount: users.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users.data![index];
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserDetail(
                      user: user,
                      updateUser: _updateUser,
                      removeUser: _removeUser,
                    ),
                  ),
                ),
                child: ListTile(
                  // leading: Image.memory(user.avatar),
                  title: Text("${user.lastName} ${user.firstName}"),
                  subtitle: Text("${user.age} y.o."),
                  trailing: IconButton(
                    onPressed: () => _removeUser(user),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
