import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/database.dart';
import 'package:intl/intl.dart';

class ListaAlimentosPage extends StatefulWidget {
  const ListaAlimentosPage({
    super.key,
    required this.tipoUsuario,
    required this.idPet,
    required this.stateAlimentacao,
    required this.stateFeedback,
    required this.idDono,
  });
  final tipoUsuario;
  final idPet;
  final stateAlimentacao;
  final stateFeedback;
  final idDono;

  @override
  State<ListaAlimentosPage> createState() => _ListaAlimentosPageState();
}

class _ListaAlimentosPageState extends State<ListaAlimentosPage> {
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

  get kPrimaryColor => null;

  getAlimentos(int index) {
    return FirebaseFirestore.instance
        .collection('alimentos')
        .where('idPet', isEqualTo: widget.idPet)
        .where('diaSemana', isEqualTo: diasdaSemana[index]);
  }

  @override
  void initState() {
    super.initState();
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
    index = date.weekday - 1;
    if (widget.tipoUsuario == 'Clientes') {
      alimentos = getAlimentos(index);
    } else {
      alimentos = getAlimentos(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    String usuario = '';
    if (widget.tipoUsuario == 'Clientes') {
      usuario = 'Nutricionistas';
    } else {
      usuario = 'Clientes';
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
      floatingActionButton: _getFAB(),
      appBar: AppBar(
        title: Text("Plano Alimentar"),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Pesquisar...',
                filled: true,
                fillColor: Colors.white,
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
              onChanged: ((value) {
                setState(() {
                  namePesquisa = value;
                });
              }),
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
                      fontSize: 20,
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
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          var idAlimento =
                              snapshot.data!.docs[index].reference.id;
                          if (namePesquisa.isEmpty) {
                            return exibirItem(data, idUsuario, idAlimento);
                          }
                          if (data['nomeAlimento']
                              .toString()
                              .toLowerCase()
                              .startsWith(namePesquisa.toLowerCase())) {
                            return exibirItem(data, idUsuario, idAlimento);
                          }
                          return Container();
                        },
                        padding: EdgeInsets.all(20),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFAB() {
    if (widget.tipoUsuario == 'Clientes') {
      return Container();
    } else {
      return FloatingActionButton(
        foregroundColor: kPrimaryColor,
        backgroundColor: kSecondColor,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(3, 152, 158, 0.73),
          size: 32,
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            'alimentacao',
            arguments: {
              'tipoUsuario': widget.tipoUsuario,
              'idAlimento': '',
              'idPet': widget.idPet,
              'idDono': widget.idDono,
              'stateAlimentacao': widget.stateAlimentacao,
              'stateFeedback': widget.stateFeedback,
            },
          );
        },
      );
    }
  }

  Widget exibirItem(item, String idUsuario, String idAlimento) {
    String? diaSemanaAlimento = item['diaSemana'];
    String? nomeAnimalAlimento = item['nomeAlimento'];
    String? horarioAlimento = item['horario'];
    String? quantidadeAlimento = item['quantidade'];
    String? descricaoAlimento = item['descricao'];

    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: EdgeInsets.all(10),
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
              style: TextStyle(
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
            Text(
              horarioAlimento.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.orange,
              ),
            ),
            Container(
              child: TextButton(
                child: Image.asset(
                  'assets/icons/feedback.png',
                  height: 40,
                  width: 40,
                  color: kPrimaryColor,
                ),
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    'listaFeedback',
                    arguments: {
                      'tipoUsuario': widget.tipoUsuario,
                      'idAlimento': idAlimento,
                      'idPet': widget.idPet,
                      'stateAlimentacao': widget.stateAlimentacao,
                      'stateFeedback': widget.stateFeedback,
                    },
                  );
                },
              ),
            ),
          ],
        ),
        onTap: () {
          if (widget.tipoUsuario == 'Clientes' &&
              !widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              !widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario == 'Clientes' &&
              widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario == 'Clientes' &&
              !widget.stateAlimentacao &&
              widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              !widget.stateAlimentacao &&
              widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'alimentacao',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idAlimento': idAlimento,
                'idPet': widget.idPet,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else {
            Navigator.pop(context);
          }
        },
        onLongPress: () {
          dialog(idUsuario, idAlimento, context);
        },
      ),
    );
  }
}

Future<void> dialog(String idUsuario, String idAlimento, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir Pet?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Você excluirá permanentemente o Pet junto com seus alimentos!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Excluir'),
            onPressed: () async {
              try {
                //await Pets().deletePet(idPet);
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao Excluir o Animal"),
                    duration: Duration(
                      seconds: 2,
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
