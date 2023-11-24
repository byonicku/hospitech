import 'package:sqflite/sqflite.dart' as sql;
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

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
        jenis_kelamin TEXT,
        profile_photo TEXT
      )
    """);

    await database.execute("""
      CREATE TABLE DAFTAR_PERIKSA (
        id_periksa INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama_pasien TEXT,
        dokter_spesialis TEXT,
        jenis_perawatan TEXT,
        tanggal_periksa TEXT,
        gambar_dokter TEXT,
        ruangan TEXT,
        price INTEGER,
        status_checkin INTEGER
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
      'profile_photo': null
    };

    return await db.insert('user', data);
  }

  static Future<int> addDaftarPeriksa(
      String namaPasien,
      String dokterSpesialis,
      String jenisPerawatan,
      String tanggalPeriksa,
      String gambarDokter,
      int price,
      String ruangan) async {
    final db = await SQLHelper.db();
    final data = {
      'nama_pasien': namaPasien,
      'dokter_spesialis': dokterSpesialis,
      'jenis_perawatan': jenisPerawatan,
      'tanggal_periksa': tanggalPeriksa,
      'gambar_dokter': gambarDokter,
      'ruangan': ruangan,
      'price': price,
      'status_checkin': 0
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
      String decodedImage) async {
    final db = await SQLHelper.db();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'no_telp': noTelp,
      'tanggal_lahir': tglLahir,
      'jenis_kelamin': jenisKelamin,
      'profile_photo': decodedImage
    };

    return await db.update('user', data, where: 'id = $id');
  }

  static Future<int> editDaftarPeriksa(
      int idPeriksa,
      String namaPasien,
      String dokterSpesialis,
      String jenisPerawatan,
      String tanggalPeriksa,
      String gambarDokter,
      String ruangan,
      int price,
      int status) async {
    final db = await SQLHelper.db();
    final updatedData = {
      'nama_pasien': namaPasien,
      'dokter_spesialis': dokterSpesialis,
      'jenis_perawatan': jenisPerawatan,
      'tanggal_periksa': tanggalPeriksa,
      'gambar_dokter': gambarDokter,
      'ruangan': ruangan,
      'price': price,
      'status_checkin': status
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
    final data = await db
        .query('user', where: 'email = ?', whereArgs: [email], columns: ['id']);
    return data.isNotEmpty;
  }

  static Future<bool> checkUsername(String? username) async {
    final db = await SQLHelper.db();
    final data = await db.query('user',
        where: 'username = ?', whereArgs: [username], columns: ['id']);
    return data.isNotEmpty;
  }

  static Future<bool> checkLogin(String? username, String? password) async {
    final db = await SQLHelper.db();
    final data = await db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
        columns: ['id']);
    return data.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getID(
      String? username, String? password) async {
    final db = await SQLHelper.db();
    final data = await db
        .query('user', where: 'username = ? AND password = ?', whereArgs: [
      username,
      password
    ], columns: [
      'id',
      'username',
      'password',
      'email',
      'tanggal_lahir',
      'no_telp',
      'jenis_kelamin'
    ]);
    return data;
  }

  static Future<User> getUserByID(int? id) async {
    final db = await SQLHelper.db();
    final dataUser = await db.query('user', where: 'id = ?', whereArgs: [
      id.toString()
    ], columns: [
      'id',
      'username',
      'email',
      'no_telp',
      'tanggal_lahir',
      'jenis_kelamin',
      'password'
    ]);
    final dataProfilePicture = await db.query('user',
        where: 'id = ?',
        whereArgs: [id.toString()],
        columns: ['profile_photo']);

    List<Map<String, dynamic>> userData = dataUser;
    Map<String, dynamic> userPhotoProfile = dataProfilePicture.first;

    User data = User(
        id: userData.first['id'],
        username: userData.first['username'],
        email: userData.first['email'],
        jenisKelamin: userData.first['jenis_kelamin'],
        noTelp: userData.first['no_telp'],
        password: userData.first['password'],
        tglLahir: userData.first['tanggal_lahir'],
        profilePhoto: userPhotoProfile['profile_photo']);
    return data;
  }

  static Future<void> updateUserByID(int? id, Map<String, dynamic> user) async {
    final db = await SQLHelper.db();
    await db.update('user', user, where: 'id = ?', whereArgs: [id.toString()]);
  }

  static Future<Periksa> getPeriksaByID(int? id) async {
    final db = await SQLHelper.db();
    final dataPeriksa =
        await db.query('daftar_periksa', where: 'id_periksa = ?', whereArgs: [
      id.toString()
    ], columns: [
      'id_periksa',
      'nama_pasien',
      'dokter_spesialis',
      'jenis_perawatan',
      'tanggal_periksa',
      'gambar_dokter',
      'ruangan',
      'price',
      'status_checkin'
    ]);

    List<Map<String, dynamic>> periksaData = dataPeriksa;

    Periksa data = Periksa(
        id: periksaData.first['id_periksa'],
        namaPasien: periksaData.first['nama_pasien'],
        dokterSpesialis: periksaData.first['dokter_spesialis'],
        jenisPerawatan: periksaData.first['jenis_perawatan'],
        tanggalPeriksa: periksaData.first['tanggal_periksa'],
        gambarDokter: periksaData.first['gambar_dokter'],
        ruangan: periksaData.first['ruangan'],
        price: periksaData.first['price'],
        statusCheckin: periksaData.first['status_checkin']);
    return data;
  }
}
