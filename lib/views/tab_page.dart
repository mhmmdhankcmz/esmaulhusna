
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:esmaulhusna/admob/ad_helper.dart';
import 'package:esmaulhusna/database_access_object/isimler_dao.dart';
import 'package:esmaulhusna/views/home.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Tab_Page extends StatefulWidget {
  late int id;
  late String isim;
  late int zikirSayisi;
  late String fazilet;
  late int zikirSayac ;


   Tab_Page({required this.id,required this.isim,required this.zikirSayisi,required this.fazilet,required this.zikirSayac});

  @override
  State<Tab_Page> createState() => _Tab_PageState();
}

class _Tab_PageState extends State<Tab_Page>  with TickerProviderStateMixin{


  Future<void> zikirSifirlama() async{
      widget.zikirSayac = 0;
    await IsimlerDao().zikirSifirla(widget.id,widget.zikirSayac);
    print("id : ${widget.id} İsim ${widget.isim}  zikir Sayacı sıfırlandı = ${widget.zikirSayac}");
  }

  Future<void> zikirSayaci() async{
    setState(() {
      if(widget.zikirSayac == widget.zikirSayisi){
        widget.zikirSayac++;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.isim} Esması Tamamlandı")));
      }else{
        widget.zikirSayac++;
      }
    });
    setState(() {
      IsimlerDao().zikirCek(widget.id,widget.zikirSayac);
    });
    print("id : ${widget.id} İsim ${widget.isim}  zikir Sayacı  = ${widget.zikirSayac}");
  }

  ScreenshotController screenshotController = ScreenshotController();
  BannerAd? _banner;

  void initState() {
    super.initState();
    _createBannerAd();

  }

  void _createBannerAd(){
    _banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (
            AppBar(centerTitle: true,iconTheme: IconThemeData(color: Colors.black),
              title: Text("${widget.isim}",style: TextStyle(color: Colors.black),),
              leading: IconButton(onPressed: () async{
                setState(() {

                });
                await IsimlerDao().tumIsimler();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
              }, icon: Icon(Icons.arrow_back)),
              actions: [
               PopupMenuButton(itemBuilder: (context)=>[
                     PopupMenuItem(child: TextButton.icon(icon: Icon(Icons.restart_alt),onPressed: (){
                       zikirSifirlama();
                       setState(() {
                       });
                     }, label: Text("Zikri Sıfırla"))),

                     PopupMenuItem(child: TextButton.icon(icon: Icon(Icons.share),onPressed: ()async{
                       final image = await screenshotController.capture();
                       if(image == null) return;
                       await saveImage(image);
                       saveAndShare(image);
                     }, label: Text("Paylaş"))),
                   ],elevation: 50,color: Colors.black,
               ),
              ],
            )
        ),
        body:Screenshot(controller: screenshotController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/background/2.jpg"),
                      fit: BoxFit.cover,
                    )
                ),
                  child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(width: 400,height: 543,
                            child: Card(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("${widget.isim}",style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(width: 300,
                                            child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text("${widget.fazilet}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),textAlign: TextAlign.center,),
                                                )),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 100.0,bottom: 30),
                                            child: Text("Günlük Zikir Sayısı : ${widget.zikirSayisi}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white70),textAlign: TextAlign.center,),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text("${widget.zikirSayac}",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold,color: Colors.white,),textAlign: TextAlign.center),
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                                  Spacer(),
                            ]
                              ),
                          ),
                        ),
                      ),
                    ),
                ),
                )
              ],
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FloatingActionButton.extended(icon: Icon(Icons.add_sharp),label: Text("Zikir Çek"),onPressed: (){
          zikirSayaci();

        }),
      ),
      bottomNavigationBar: _banner == null ? Container(child: Text("Reklam Alanı"),):
      Container(color: Colors.transparent,
        margin: const EdgeInsets.all(0),height: 100,child: AdWidget(ad: _banner!,),
      ),
    );

  }
  Future saveAndShare(Uint8List bytes) async {
    final appUrl = 'https://play.google.com/store/apps/details?id=com.mobdevs.esmaulhusna';
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/esmaulhusna.png');
    image.writeAsBytesSync(bytes);

    await Share.shareXFiles([XFile(image.path)],text: "Sende bir Müslüman ile paylaş :) \n\n $appUrl");

  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}


