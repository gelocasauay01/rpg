// External Dependencies
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBController {
  static final DBController instance = DBController._init();
  Database? _database;

  DBController._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDatabase('rpg.db');
    return _database!;
  }

  Future<Database> _initDatabase(String  fileName) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database database, int version) async {
    Batch batch = database.batch();
    batch.execute('''
      CREATE TABLE Quest(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Deadline INTEGER
      )
    ''');

    batch.execute('''
      CREATE TABLE Subtask(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        QuestId INTEGER NOT NULL,
        Title TEXT NOT NULL,
        IsDone BOOLEAN NOT NULL,
        FOREIGN KEY(QuestId) REFERENCES Quest(Id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE Skill(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Level INTEGER NOT NULL,
        CurrentExp INTEGER NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE SkillReward(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        QuestId INTEGER NOT NULL,
        SkillId INTEGER NOT NULL,
        Difficulty INTEGER NOT NULL,
        FOREIGN KEY(QuestId) REFERENCES Quest(Id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY(SkillId) REFERENCES Skill(Id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE SkillUsage(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        SkillId INTEGER NOT NULL,
        DateUsage TEXT NOT NULL,
        Difficulty INTEGER NOT NULL,
        FOREIGN KEY(SkillId) REFERENCES Skill(Id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE BadHabit(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Damage INTEGER NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE BadHabitOccurrence(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        BadHabitId INTEGER NOT NULL,
        DateOccurred INTEGER NOT NULL,
        FOREIGN KEY(BadHabitId) REFERENCES BadHabit(Id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE QuestHistory(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        DateFinished TEXT NOT NULL,
        Difficulty INTEGER NOT NULL,
        IsFinished BOOLEAN NOT NULL
      )
    ''');

    await batch.commit();
  }

  Future<void> close() async {
    Database database = await instance.database;
    database.close();
  }
}