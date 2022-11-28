import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Pets {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createPets(
      String nome,
      String tipo,
      String raca,
      String cor,
      String sexo,
      double idade,
      double peso,
      String alergia,
      String rejeicao,
      String problemas,
      String observacoes,
      String descricao,
      context) async {
    Map<String, dynamic> petsInfoMap = {
      'idDono': auth.currentUser?.uid,
      'nome': nome,
      'tipo': tipo,
      'raca': raca,
      'cor': cor,
      'sexo': sexo,
      'peso': peso,
      'idade': idade,
      'alergia': alergia,
      'rejeicao': rejeicao,
      'problemas': problemas,
      'observacoes': observacoes,
      'descricao': descricao
    };

    DatabaseMethods().addPetsInfoToDB(petsInfoMap);
  }

  Future<void> updatePets(
      String nome,
      String tipo,
      String raca,
      String cor,
      String sexo,
      double idade,
      double peso,
      String alergia,
      String rejeicao,
      String problemas,
      String observacoes,
      String descricao,
      idPet,
      context) async {
    Map<String, dynamic> petsInfoMap = {
      'idDono': auth.currentUser?.uid,
      'nome': nome,
      'tipo': tipo,
      'raca': raca,
      'cor': cor,
      'sexo': sexo,
      'peso': peso,
      'idade': idade,
      'alergia': alergia,
      'rejeicao': rejeicao,
      'problemas': problemas,
      'observacoes': observacoes,
      'descricao': descricao
    };

    DatabaseMethods().updatePetsInfoToDB(petsInfoMap, idPet);
  }

  Future<void> deletePet(idPet) async {
    await DatabaseMethods().deletePetsInfoToDB(idPet);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
