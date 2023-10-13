import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE USER (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT,
        email TEXT UNIQUE,
        password TEXT,
        no_telp TEXT,
        tanggal_lahir TEXT,
        jenis_kelamin TEXT
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> addUser(
    String username,
    String email,
    String password,
    String noTelp,
    String tglLahir,
    String jenisKelamin,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'no_telp': noTelp,
      'tanggal_lahir': tglLahir,
      'jenis_kelamin': jenisKelamin,
    };

    return await db.insert('user', data);
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  static Future<int> editUser(
    int id,
    String username,
    String email,
    String password,
    String noTelp,
    String tglLahir,
    String jenisKelamin,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'no_telp': noTelp,
      'tanggal_lahir': tglLahir,
      'jenis_kelamin': jenisKelamin,
    };

    return await db.update('user', data, where: 'id = $id');
  }

  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: 'id = $id');
  }

  static Future<bool> checkEmail(String? email) async {
    final db = await SQLHelper.db();
    final data = await db.query('user', where: 'email = ?', whereArgs: [email]);
    return data.isNotEmpty;
  }

  static Future<bool> checkLogin(String? username, String? password) async {
    final db = await SQLHelper.db();
    final data = await db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return data.isNotEmpty;
  }
}
