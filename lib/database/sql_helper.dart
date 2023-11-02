import 'package:sqflite/sqflite.dart' as sql;

// creating database ========================================================================================
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

    await database.execute("""
      CREATE TABLE DAFTAR_PERIKSA (
        id_periksa INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama_pasien TEXT,
        dokter_spesialis TEXT,
        jenis_perawatan TEXT,
        tanggal_periksa TEXT,
        gambar_dokter TEXT
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // Adding data to database ========================================================================================
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

  static Future<int> addDaftarPeriksa(String namaPasien, String dokterSpesialis,
      String jenisPerawatan, String tanggalPeriksa, String gambarDokter) async {
    final db = await SQLHelper.db();
    final data = {
      'nama_pasien': namaPasien,
      'dokter_spesialis': dokterSpesialis,
      'jenis_perawatan': jenisPerawatan,
      'tanggal_periksa': tanggalPeriksa,
      'gambar_dokter': gambarDokter
    };

    return await db.insert('daftar_periksa', data);
  }

  // Getting data from database ========================================================================================
  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  static Future<List<Map<String, dynamic>>> getDaftarPeriksa() async {
    final db = await SQLHelper.db();
    return db.query('daftar_periksa');
  }

  // Editing data in database ========================================================================================
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

  static Future<int> editDaftarPeriksa(
      int idPeriksa,
      String namaPasien,
      String dokterSpesialis,
      String jenisPerawatan,
      String tanggalPeriksa,
      String gambarDokter) async {
    final db = await SQLHelper.db();
    final updatedData = {
      'nama_pasien': namaPasien,
      'dokter_spesialis': dokterSpesialis,
      'jenis_perawatan': jenisPerawatan,
      'tanggal_periksa': tanggalPeriksa,
      'gambar_dokter': gambarDokter,
    };

    return await db.update('daftar_periksa', updatedData,
        where: 'id_periksa = $idPeriksa');
  }

  // Delete data in database ========================================================================================
  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: 'id = $id');
  }

  static Future<int> deleteDaftarPeriksa(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('daftar_periksa', where: 'id_periksa = $id');
  }

  // checking into database ========================================================================================
  static Future<bool> checkEmail(String? email) async {
    final db = await SQLHelper.db();
    final data = await db.query('user', where: 'email = ?', whereArgs: [email]);
    return data.isNotEmpty;
  }

  static Future<bool> checkUsername(String? username) async {
    final db = await SQLHelper.db();
    final data =
        await db.query('user', where: 'username = ?', whereArgs: [username]);
    return data.isNotEmpty;
  }

  static Future<bool> checkLogin(String? username, String? password) async {
    final db = await SQLHelper.db();
    final data = await db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return data.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getID(
      String? username, String? password) async {
    final db = await SQLHelper.db();
    final data = await db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> getUserByID(int? id) async {
    final db = await SQLHelper.db();
    final data =
        await db.query('user', where: 'id = ?', whereArgs: [id.toString()]);
    return data;
  }

  static Future<void> updateUserByID(int? id, Map<String, dynamic> user) async {
    final db = await SQLHelper.db();
    await db.update('user', user, where: 'id = ?', whereArgs: [id.toString()]);
  }
}
