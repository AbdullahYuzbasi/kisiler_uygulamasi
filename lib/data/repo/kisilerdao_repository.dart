import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/sqlite/veritabani_yardimcisi.dart';

class KisilerDaoRepository{

  Future<void> kaydet(String kisi_ad,String kisi_tel) async {//kaydet sayfasi icin
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var yeniKisi = Map<String,dynamic>();
    yeniKisi["kisi_ad"] = kisi_ad;
    yeniKisi["kisi_tel"] = kisi_tel;
    await db.insert("kisiler", yeniKisi);  // sirasiyla (tablo adi, deger)
  }

  Future<void> guncelle(int kisi_id,String kisi_ad,String kisi_tel) async { //detay sayfasi icin
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var guncellenenKisi = Map<String,dynamic>();
    guncellenenKisi["kisi_ad"] = kisi_ad;
    guncellenenKisi["kisi_tel"] = kisi_tel;
    await db.update("kisiler", guncellenenKisi,
      where: "kisi_id = ?",
      whereArgs:[kisi_id],
    );
  }

  Future<void> sil(int kisi_id) async{  //ana sayfa SILME ISLEMI
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("kisiler",
      where: "kisi_id = ?",
      whereArgs:[kisi_id],
    );
  }

  Future<List<Kisiler>> kisileriYukle() async{  //ana sayfa KISILERI YUKLEME    //liste icinde kisiler clasindan nesneler olacak.
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps = await db.rawQuery("Select * From kisiler");   //anahtar(kisi_id,ad,tel) - deger(1,Ali,9999) gibi dusun.Veritabaninda maplerimiz var mesele ( Ali 9999 ) gibi. Bunlar listeye donusturulecek.
    //artik bu listeden veri alabiliriz.
    //kisiler nesnesinden bir listeye ihtiyacimiz var ( yukardaki su kisim: <List<Kisiler>> )

    //olusan listeden satir satir (map) verileri alacagiz
    return List.generate(maps.length, (index) {
      var satir = maps[index];
      return Kisiler(kisi_id: satir["kisi_id"], kisi_ad: satir["kisi_ad"], kisi_tel: satir["kisi_tel"]);
      //map uzunlugu kadar satir gelicek ve gelirkende id,ad,tel bilgileri listeye donusuturlecek
    });
  }

  Future<List<Kisiler>> ara(String aramaKelimesi) async{   //kisileri yukleme ile neredeyse ayni tek fark sorgu sekli
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps = await db.rawQuery("Select * From kisiler WHERE kisi_ad like '%$aramaKelimesi%'");

    return List.generate(maps.length, (index) {
      var satir = maps[index];
      return Kisiler(kisi_id: satir["kisi_id"], kisi_ad: satir["kisi_ad"], kisi_tel: satir["kisi_tel"]);
    });
  }

}
