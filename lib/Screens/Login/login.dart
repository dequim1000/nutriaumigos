import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutriaumigos/Screens/Login/cadastro.dart';
import 'package:nutriaumigos/Screens/Login/recuperacao_senha.dart';
import 'package:nutriaumigos/Screens/Menu/home.page.dart';
import 'package:nutriaumigos/Models/auth.dart';

import '../../constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var txtEmail = TextEditingController();
    var txtSenha = TextEditingController();
    return Scaffold(
      body: Container(
        color: kPrimaryLightColor,
        padding: const EdgeInsets.only(
          top: 40,
          left: 40,
          right: 40,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 224,
              height: 224,
              child: Image.asset("assets/images/Logo.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtEmail,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: txtSenha,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text(
                  "Recuperar Senha",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecuperacaoSenhaPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    kPrimaryColor,
                    kSecondColor,
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: Image.asset("assets/icons/paw_dog.png"),
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          wordSpacing: 10,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 32,
                        width: 32,
                        child:
                            Image.asset("assets/icons/icon_bone_verde.png"),
                      ),
                    ],
                  ),
                  onPressed: () {
                    login(txtEmail.text, txtSenha.text, context);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 40,
              child: TextButton(
                child: const Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(email, senha, context) async {
    //Navigator.pushReplacementNamed(context, 'menuPrincipal');
    try {
      await Authent().loginwithEmailAndPassword(email, senha).then((value){
        Navigator.pushReplacementNamed(context, 'menuPrincipal');
      });
    } on FirebaseException catch(e) {
      var msg = '';
      if (e.code == 'user-not-found') {
        msg = 'ERRO: Usuario não encontrado';
      } else if (e.code == 'wrong-password') {
        msg = 'ERRO: Senha incorreta';
      } else if (e.code == 'invalid-email') {
        msg = 'ERRO: Email inválido';
      } else {
        msg = 'ERRO: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    }
  }
}
