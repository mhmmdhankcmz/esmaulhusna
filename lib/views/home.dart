import 'dart:io';

import 'package:esmaulhusna/admob/ad_helper.dart';
import 'package:esmaulhusna/database_access_object/isimler_dao.dart';
import 'package:esmaulhusna/model/isimler.dart';
import 'package:esmaulhusna/views/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool aramaYapiliyormu = false;
  String aramaKelimesi = "";

  Future<List<Isimler>> esmalariGetir() async {
    return IsimlerDao().tumIsimler();
  }

  Future<List<Isimler>> aramaYap(String aramaKelimesi) async {
    return IsimlerDao().isimAra(aramaKelimesi);
  }

  BannerAd? _banner;


  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdMobService.bannerAdUnitHome!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraints) {
        contraints.maxWidth;
        contraints.maxHeight;
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: uygulamayiKapat, icon: Icon(Icons.power_settings_new)),
              centerTitle: true,
              title: aramaYapiliyormu
                  ? TextField(
                      decoration: InputDecoration(
                        hintText: "Esma ara",
                      ),
                      onChanged: (aramaSonucu) {
                        print("Arama sonucu $aramaSonucu");
                        setState(() {
                          aramaKelimesi = aramaSonucu;
                        });
                      },
                    )
                  : Text("Esma-ül Hüsna",
                      style: TextStyle(color: Colors.white70)),
              actions: [
                aramaYapiliyormu
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            aramaYapiliyormu = false;
                            aramaKelimesi = "";
                          });
                        },
                        icon: Icon(Icons.cancel))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            aramaYapiliyormu = true;
                          });
                        },
                        icon: Icon(Icons.search)),
              ],
            ),
            body: WillPopScope(
              onWillPop: uygulamayiKapat,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/background/2.jpg"),
                  fit: BoxFit.cover,
                )),
                child: FutureBuilder<List<Isimler>>(
                  future: aramaYap(aramaKelimesi),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var isimlerListesi = snapshot.data;
                      return ListView.builder(
                        itemCount: isimlerListesi?.length,
                        itemBuilder: (context, index) {

                          var isim = isimlerListesi![index];

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: SizedBox(
                              height: 50,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Tab_Page(
                                                id: isim.id,
                                                isim: isim.isim,
                                                fazilet: isim.fazilet,
                                                zikirSayisi: isim.zikirSayisi,
                                                zikirSayac: isim.zikir,
                                              )));
                                },
                                child: Card(
                                    color: Colors.transparent,
                                    elevation: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${isim.id}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white54),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "${isim.isim}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Text("${isim.zikir}",
                                            style: TextStyle(fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white54),),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/background/2.jpg"),
                            fit: BoxFit.cover,
                          )),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Lütfen Bekleyiniz veya Daha sonra tekrar deneyiniz..",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              CircularProgressIndicator(),
                            ],
                          )));
                    }
                  },
                ),
              ),
            ),
            bottomNavigationBar: _banner == null
                ? Container(
                    child: Text("Reklam Alanı"),
                  )
                : Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(0),
                    height: 100,
                    child: AdWidget(
                      ad: _banner!,
                    ),
                  ));
      },
    );
  }
}
