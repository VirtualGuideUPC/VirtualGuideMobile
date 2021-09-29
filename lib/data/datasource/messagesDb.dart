// Get a location using getDatabasesPath
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tour_guide/data/entities/message.dart';

class MessagesDb {
  dynamic initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'virtualGuide.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY, text TEXT, date TEXT, time TEXT, url TEXT, user INTEGER, is_user  BOOLEAN)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertMessage(Message message) async {
    final db = await initDatabase();
    await db.insert(
      'messages',
      message.ToJson(message),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Message>> getAllMessagesDb() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      var message = maps[i];
      print(message);
      return Message(
          text: maps[i]["text"],
          date: maps[i]["date"],
          time: maps[i]["time"],
          isUser: maps[i]["is_user"] == 1 ? true : false,
          url: maps[i]["url"],
          user: maps[i]["user"]);
    });
  }

  void deleteDftabase() async {
    deleteDatabase('virtualGuide.db');
  }
}
