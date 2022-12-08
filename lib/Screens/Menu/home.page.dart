import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/auth.dart';
import 'package:nutriaumigos/Models/database.dart';

import '../../Models/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String namePesquisa = '';
  var tipoUsuario;
  var alimentos;
  var nutricionista;
  String idUsuario = '';

  var date = DateTime.now();
  List diasdaSemana = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domingo'
  ];

  var index = 0;
  String usuario = '';
  String nomeUsuario = '';
  String iconeUsuario = '';
  final ICON_CLIENTE = 'assets/icons/cliente_icon.png';
  final ICON_NUTRI = 'assets/icons/nutricionista_icon.png';
  final USER_CLIENTE = 'Clientes';
  final USER_NUTRI = 'Nutricionistas';

  @override
  void initState() {
    super.initState();
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
    index = date.weekday - 1;
    alimentos = getAlimentos(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
      appBar: AppBar(
        title: const Text(
          "NutriAumigos",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: DatabaseMethods()
            .getUserFromDB(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          final crmv = snapshot.data?.data();
          if (crmv != null) {
            tipoUsuario = (crmv as Map)['crmv'];
            usuario = tipoUsuario == null || tipoUsuario == ''
                ? USER_CLIENTE
                : USER_NUTRI;
            nomeUsuario = usuario == USER_CLIENTE ? USER_NUTRI : USER_CLIENTE;
            iconeUsuario = usuario == USER_CLIENTE ? ICON_NUTRI : ICON_CLIENTE;
          } else {
            tipoUsuario = null;
          }
          return _body(context);
        },
      ),
    );
  }

  _body(context) {
    double altura = tipoUsuario == null || tipoUsuario == '' ? 100 : 350;
    return Container(
      color: kPrimaryColor,
      height: 800,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _actions(context, usuario, nomeUsuario, iconeUsuario),
              _banner(altura),
              _cardAlimentacao(context, tipoUsuario),
            ],
          ),
        ),
      ),
    );
  }

  getAlimentos(int index) {
    return FirebaseFirestore.instance
        .collection('alimentos')
        .where('idDono', isEqualTo: idUsuario)
        .where('diaSemana', isEqualTo: diasdaSemana[index]);
  }

  getPet(String idPet) {
    return FirebaseFirestore.instance.collection('pets').doc(idPet).snapshots();
  }

  _actions(
      context, String tipoUsuario, String nomeUsuario, String iconeUsuario) {
    String navegacaoTela = '';
    if (tipoUsuario == 'Clientes') {
      navegacaoTela = 'listaAnimais';
    } else {
      navegacaoTela = 'listaUsuarios';
    }
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 7,
              ),
            ),
            _buildCard(context, nomeUsuario, tipoUsuario, iconeUsuario,
                'listaUsuarios', false, false, true),
            const SizedBox(width: 4),
            _buildCard(
                context,
                'Pet',
                tipoUsuario,
                'assets/icons/animais_icon.png',
                navegacaoTela,
                false,
                false,
                false),
            const SizedBox(width: 4),
            _buildCard(
                context,
                'Alimentos',
                tipoUsuario,
                'assets/icons/alimento_icon.png',
                navegacaoTela,
                true,
                false,
                false),
            const SizedBox(width: 4),
            _buildCard(
                context,
                'FeedBack',
                tipoUsuario,
                'assets/icons/feedback_icon.png',
                navegacaoTela,
                false,
                true,
                false),
            const Padding(
              padding: EdgeInsets.only(
                right: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _banner(double altura) {
    return FutureBuilder(
      future: FireStoreDataBase().getData(usuario),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Erro ao Buscar Propaganda",
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Image.network(
              snapshot.data.toString(),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  _cardAlimentacao(context, tipoUsuario) {
    //TipoUsario Cliente
    if (tipoUsuario == '' || tipoUsuario == null) {
      return Container(
        width: 400,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: _listaAlimentos(),
      );
    } else {
      return Container();
    }
  }

  _listaAlimentos() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Plano Alimentar",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: kPrimaryLightColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              height: 50,
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          index--;
                          if (index < 0) {
                            index = 6;
                          }
                          alimentos = getAlimentos(index);
                        });
                      },
                    ),
                    Text(
                      diasdaSemana[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryLightColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          index++;
                          if (index > 6) {
                            index = 0;
                          }
                          alimentos = getAlimentos(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          child: StreamBuilder<QuerySnapshot>(
            //fonte de dados (coleção)
            stream: alimentos.snapshots(),

            //exibir os dados recuperados
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: Text('Não foi possível conectar ao Firestore'),
                  );

                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  return Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        AppBar().preferredSize.height -
                        300,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        var idAlimento =
                            snapshot.data!.docs[index].reference.id;
                        return exibirItem(data, idUsuario, idAlimento);
                      },
                      padding: EdgeInsets.all(20),
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget exibirItem(item, String idUsuario, String idAlimento) {
    String? diaSemanaAlimento = item['diaSemana'];
    String? nomeAnimalAlimento = item['nomeAlimento'];
    String? horarioAlimento = item['horario'];
    String? quantidadeAlimento = item['quantidade'];
    String? descricaoAlimento = item['descricao'];
    String? nomePet = item['nomePet'];

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //leading: Image.asset('assets/icons/osso-de-cao.png'),
        title: Text(
          nomeAnimalAlimento.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              descricaoAlimento.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
              ),
            ),
            Text(
              quantidadeAlimento.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kSecondColor,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  horarioAlimento.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  nomePet.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            Container(
              child: TextButton(
                child: Image.asset(
                  'assets/icons/osso-de-cao.png',
                  height: 40,
                  width: 40,
                  color: kSecondColor,
                ),
                onPressed: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCard(
      BuildContext context,
      String tituloCard,
      String tipoUsuario,
      String imageButton,
      String nomeTela,
      bool stateAlimentacao,
      bool stateFeedback,
      bool statePets) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, nomeTela, arguments: {
                'tipoUsuario': tipoUsuario,
                'stateAlimentacao': stateAlimentacao,
                'stateFeedback': stateFeedback,
                'statePets': statePets,
              })
            },
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(239, 239, 239, 1),
                border: Border.all(
                    color: const Color.fromRGBO(239, 239, 239, 1),
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(
                    Radius.circular(10.0)), // Set rounded corner radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(imageButton, height: 37, width: 37),
              ),
            ),
          ),
          Text(
            tituloCard,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14),
          )
        ],
      ),
    );
  }
}
