import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Alimentos{
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  Future<User> getcurrentUser() async{
    return await auth.currentUser!;
  } 

  Future<void> createAlimento(
      String idPet,
      String idDono,
      String diaSemana,
      String nomeAlimento,
      String nomePet,
      String horario,
      String quantidade,
      String descricao,
      context) async {
    Map<String, dynamic> petsInfoMap = {
      'idNutri': auth.currentUser?.uid,
      'idPet': idPet,
      'idDono': idDono,
      'diaSemana': diaSemana,
      'nomeAlimento': nomeAlimento,
      'nomePet': nomePet,
      'horario': horario,
      'quantidade': quantidade,
      'descricao': descricao,
    };

    DatabaseMethods().addAlimentosInfoToDB(petsInfoMap);
  }

  Future<void> updateAlimento(
      String idPet,
      String idDono,
      String diaSemana,
      String nomeAlimento,
      String nomePet,
      String horario,
      String quantidade,
      String descricao,
      idAlimento,
      context) async {
    Map<String, dynamic> petsInfoMap = {
      'idNutri': auth.currentUser?.uid,
      'idPet': idPet,
      'idDono': idDono,
      'diaSemana': diaSemana,
      'nomeAlimento': nomeAlimento,
      'nomePet': nomePet,
      'horario': horario,
      'quantidade': quantidade,
      'descricao': descricao,
    };

    DatabaseMethods().updateAlimentosInfoToDB(petsInfoMap, idAlimento);
  }

  Future<void> deleteAlimento(idPet) async {
    await DatabaseMethods().deletePetsInfoToDB(idPet);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}