import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  String? downloadURL;

  Future getData(String tipoUsuario) async {
    try {
      if(tipoUsuario == "Clientes"){
        await downloadClienteURLExample();
      }else{
        await downloadNutriURLExample();
      }
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadClienteURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("propaganda_cliente.png")
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }

  Future<void> downloadNutriURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("propaganda_nutri.png")
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}