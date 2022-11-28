import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class FeedbackClass {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getcurrentUser() async {
    return await auth.currentUser!;
  }

  Future<void> createFeedback(
      String idPet,
      String idAlimento,
      String avaliacao,
      String rejeicao,
      String quantidade,
      String observacao,
      String resposta,
      context) async {
    Map<String, dynamic> feedBackInfoMap = {
      'idCliente': auth.currentUser?.uid,
      'idPet': idPet,
      'idAlimento': idAlimento,
      'avaliacao': avaliacao,
      'rejeicao': rejeicao,
      'quantidade': quantidade,
      'observacao': observacao,
      'resposta': resposta,
    };

    DatabaseMethods().addFeedbackInfoToDB(feedBackInfoMap);
  }

  Future<void> updateFeedback(
      String idPet,
      String idAlimento,
      String avaliacao,
      String rejeicao,
      String quantidade,
      String observacao,
      String resposta,
      idFeedback,
      context) async {
    Map<String, dynamic> feedBackInfoMap = {
      'idCliente': auth.currentUser?.uid,
      'idPet': idPet,
      'idAlimento': idAlimento,
      'avaliacao': avaliacao,
      'rejeicao': rejeicao,
      'quantidade': quantidade,
      'observacao': observacao,
      'resposta': resposta,
    };

    DatabaseMethods().updateFeedbackInfoToDB(feedBackInfoMap, idFeedback);
  }

  Future<void> deleteFeedback(idFeedback) async {
    await DatabaseMethods().deleteFeedbackInfoToDB(idFeedback);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
