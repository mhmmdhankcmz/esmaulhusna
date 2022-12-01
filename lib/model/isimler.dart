class Isimler{
  late int id;
  late String isim;
  late int zikirSayisi;
  late String fazilet;
  late int zikir;

  Isimler({required this.id, required this.isim,required this.zikirSayisi,required this.fazilet,required this.zikir});

  factory Isimler.fromMap(Map<String, dynamic> json) => Isimler(
    id: json["id"],
    isim: json["isim"],
    zikirSayisi: json["zikirSayisi"],
    fazilet: json["fazilet"],
    zikir: json["zikir"]
  );
}