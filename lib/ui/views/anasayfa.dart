import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:kisiler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kisiler_uygulamasi/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;


  @override
  void initState() {                        //sayfa acildigi gibi kisileri kisileri getirmesi icin yaptik
    super.initState();
    context.read<AnasayfaCubit>().kisileriYukle();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ?                //kosull
        TextField(decoration: const InputDecoration(hintText: "Kisi Ara"),
          onChanged: (aramaSonucu){        //harf girdikce sonuc getiricek.
            context.read<AnasayfaCubit>().ara(aramaSonucu);
          },
        ): const Text("Kisiler"),
        backgroundColor: Colors.deepPurpleAccent,

        actions: [                                  //kosull
          aramaYapiliyorMu ? IconButton(
              onPressed: (){
                setState(() {
                  aramaYapiliyorMu = false;
                });
                context.read<AnasayfaCubit>().kisileriYukle();//aramadan vazgecilirse ve carpiya basilirsa ekrana yine butun listeyi getirmeli
              },
              icon: Icon(Icons.clear,
                  color: Colors.black),
          ): IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
            icon: Icon(Icons.search,
                color: Colors.black),
          ),
        ],
      ),
      body: BlocBuilder<AnasayfaCubit,List<Kisiler>>(//Future<List<Kisiler>> icine koyduklarimizi arayuzde gostermek icin kullaniyoruz
          builder: (context,kisilerListesi){
            if(kisilerListesi.isNotEmpty){
              return ListView.builder(              //datalari goruntulemek icin
                itemCount: kisilerListesi.length,  //3 tane nesne var
                itemBuilder: (context,index){       //sirayla 1,2 ve 3. indexler icin calisir.
                  var kisi = kisilerListesi[index];
                  return GestureDetector(
                    onTap: (){
                      //print("${kisi.kisi_ad} secildi"); kontrol amacli
                      Navigator.push(context,MaterialPageRoute(builder: (context) => DetaySayfa(kisi:kisi)))
                          .then((value){
                        context.read<AnasayfaCubit>().kisileriYukle();
                      });
                    },
                    child: Card(    //arayuzdeki acik mor renkli bolum
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(kisi.kisi_ad,style: const TextStyle(fontSize: 20),),
                                  Text(kisi.kisi_tel),
                                ],
                              ),
                            ),
                            const Spacer(),   //bulunan bosluk kadar icon saga gider.
                            IconButton(
                                onPressed: (){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${kisi.kisi_ad} Silinsin Mi ?"),
                                      action: SnackBarAction(
                                          label: "EVET",
                                          onPressed: (){
                                            context.read<AnasayfaCubit>().sil(kisi.kisi_id);
                                          },
                                      ),
                                      ),
                                  );
                                },
                                icon: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return const Center();   //bos sayfa
            }
          },
        ),

      floatingActionButton:FloatingActionButton (
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => const KayitSayfa()))
          .then((value){
            context.read<AnasayfaCubit>().kisileriYukle();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
