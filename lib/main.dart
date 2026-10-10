import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  var box = await Hive.openBox<UserModel>('users');

  if (box.isEmpty) {
    box.add(UserModel(id: 1, name: 'Ahmed Ali', email: 'ahmed@gmail.com'));
    box.add(UserModel(id: 2, name: 'Sara Mohamed', email: 'sara@gmail.com'));
    box.add(UserModel(id: 3, name: 'John Smith', email: 'john@gmail.com'));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Users Task',
      theme: ThemeData(primarySwatch: Colors.blue),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Users (Hive)'),
        centerTitle: true,
      ),

      body: ValueListenableBuilder<Box<UserModel>>(
        valueListenable: Hive.box<UserModel>('users').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No users cached yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              // جلب المستخدم حسب الـ index
              UserModel user = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            backgroundColor: Colors.red,
            onPressed: () {
              if (box.isNotEmpty) {
                box.deleteAt(box.length - 1);
              }
            },
            child: const Icon(Icons.remove, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              box.add(
                UserModel(
                  id: 4,
                  name: 'Bavly Romany ',
                  email: 'bavly@gmail.com',
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
