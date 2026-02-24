import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/ui/cubit/kayit_sayfa_cubit.dart';

class KayitSayfa extends StatefulWidget {
  const KayitSayfa({super.key});

  @override
  State<KayitSayfa> createState() => _KayitSayfaState();
}

class _KayitSayfaState extends State<KayitSayfa> {
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayit Sayfa"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 40,right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(controller: tfKisiAdi,decoration: InputDecoration(hintText: "Kisi Ad Giriniz"),),
              TextField(controller: tfKisiTel,decoration: InputDecoration(hintText: "Kisi Tel Giriniz"),),
              ElevatedButton(
                  onPressed: (){
                    context.read<KayitSayfaCubit>().kaydet(tfKisiAdi.text, tfKisiTel.text);
                  },
                  child: Text("KAYDET"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
