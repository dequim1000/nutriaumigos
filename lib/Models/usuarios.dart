import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Usuarios{
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  Future<User> getcurrentUser() async{
    return await auth.currentUser!;
  } 
  Future<void> createUsers(
    String idClientes, String idNutri, context) async {
    
    Map<String, dynamic> usersInfoMap = {
      'idClientes': idClientes,
      'idNutri': idNutri,
    };

    DatabaseMethods().addUsersInfoToDB(usersInfoMap);
  }

  Future<void> getNutriToClientes(String idClientes) async {
    DatabaseMethods().getNutritoClientesFromDB(idClientes);
  }

  Future<void> getClientesToNutri(String idNutri) async {
    DatabaseMethods().getClientestoNutriFromDB(idNutri);
  }
}