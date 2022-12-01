import 'package:esmaulhusna/db_helper/db_helper.dart';
import 'package:esmaulhusna/model/isimler.dart';

class IsimlerDao {

  Future<List<Isimler>> tumIsimler() async {
    var db = await DbHelper.dbAccess();

    var response = await db.rawQuery("SELECT * FROM esma");
    List<Isimler> list = response.map((c) => Isimler.fromMap(c)).toList();
    return list;
  }

  Future<List<Isimler>> isimAra(String aramaKelimesi) async {
    var db = await DbHelper.dbAccess();

    var response = await db
        .rawQuery("SELECT * FROM esma WHERE isim like'%${aramaKelimesi}%'");
    List<Isimler> list = response.map((c) => Isimler.fromMap(c)).toList();
    return list;
  }

  Future<void> zikirCek(int id,int zikir) async{
    var db = await DbHelper.dbAccess();
    var bilgiler = Map<String,int>();
    bilgiler["zikir"] = zikir;
    await db.update("esma", bilgiler,where: "id= ?", whereArgs: [id]);
  }

  Future<void> zikirSifirla(int id,int zikir) async{
    var db = await DbHelper.dbAccess();
    var bilgiler = Map<String,int>();
    bilgiler["zikir"] = zikir;
    await db.update("esma", bilgiler,where: "id= ?", whereArgs: [id]);
  }




}
