import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutriaumigos/Screens/Alimentacao/alimentacao.dart';
import 'package:nutriaumigos/Screens/Alimentacao/listaAlimentosPage.dart';
import 'package:nutriaumigos/Screens/Animais/listaAnimaisPage.dart';
import 'package:nutriaumigos/Screens/Feedback/feedback.dart';
import 'package:nutriaumigos/Screens/Feedback/listaFeedback.dart';
import 'package:nutriaumigos/Screens/Login/cadastro.dart';
import 'package:nutriaumigos/Screens/Login/recuperacao_senha.dart';
import 'package:nutriaumigos/Screens/Menu/home.page.dart';
import 'package:nutriaumigos/Screens/usuarios/usariosPage.dart';
import 'package:nutriaumigos/constants.dart';

import 'Screens/Animais/animais.dart';
import 'Screens/Chat/ChatScreen.dart';
import 'Screens/Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutri Aumigos',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: const LoginPage(),
      routes: {
        'login': (context) => const LoginPage(),
        'cadastro': (context) => const CadastroPage(),
        'recuperacao': (context) => const RecuperacaoSenhaPage(),
        'menuPrincipal': (context) => const HomePage(),
        'alimentacao': (context) => AlimentacaoPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              idAlimento: (ModalRoute.of(context)?.settings.arguments
                  as Map)['idAlimento'],
              idPet:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idPet'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
              idDono:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idDono'],
            ),
        'animais': (context) => AnimaisPage(
              idPet:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idPet'],
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
            ),
        'listaUsuarios': (context) => UsuariosPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
              statePets: (ModalRoute.of(context)?.settings.arguments
                  as Map)['statePets'],
            ),
        'listaAnimais': (context) => ListaAnimaisPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
              idDono:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idDono'],
            ),
        'listaAlimentos': (context) => ListaAlimentosPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              idPet:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idPet'],
              idDono:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idDono'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
            ),
        'feedback': (context) => FeedbackPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              idPet:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idPet'],
              idAlimento: (ModalRoute.of(context)?.settings.arguments
                  as Map)['idAlimento'],
              idFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['idFeedback'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
            ),
        'listaFeedback': ((context) => ListaFeedbackPage(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              idPet:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idPet'],
              idAlimento: (ModalRoute.of(context)?.settings.arguments
                  as Map)['idAlimento'],
              stateAlimentacao: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateAlimentacao'],
              stateFeedback: (ModalRoute.of(context)?.settings.arguments
                  as Map)['stateFeedback'],
            )),
        '/chat': (context) => ChatScreen(
              tipoUsuario: (ModalRoute.of(context)?.settings.arguments
                  as Map)['tipoUsuario'],
              idItem:
                  (ModalRoute.of(context)?.settings.arguments as Map)['idItem'],
            ),
      },
    );
  }
}
