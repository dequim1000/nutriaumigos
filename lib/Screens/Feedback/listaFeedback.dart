import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/database.dart';
import 'package:nutriaumigos/Models/feedback.dart';
import 'package:nutriaumigos/Models/pets.dart';

class ListaFeedbackPage extends StatefulWidget {
  const ListaFeedbackPage(
      {super.key,
      required this.tipoUsuario,
      required this.stateAlimentacao,
      required this.stateFeedback,
      required this.idPet,
      required this.idAlimento});
  final tipoUsuario;
  final stateAlimentacao;
  final stateFeedback;
  final idPet;
  final idAlimento;

  @override
  State<ListaFeedbackPage> createState() => _ListaFeedbackPageState();
}

class _ListaFeedbackPageState extends State<ListaFeedbackPage> {
  String namePesquisa = '';
  var tipoUsuario;
  var feedback;
  String idUsuario = '';
  List allData = [];
  var listaAux;

  get kPrimaryColor => null;

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("replyFeedback");

  Future<void> getDataReply(String idFeedback) async {
    QuerySnapshot querySnapshot = await _collectionReference
        .where("idFeedback", isEqualTo: idFeedback)
        .get();

    setState(() {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
    feedback = FirebaseFirestore.instance
        .collection('feedback')
        .where('idAlimento', isEqualTo: widget.idAlimento);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
      floatingActionButton: _getFAB(),
      appBar: AppBar(
        title: Text("Feedbacks"),
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
            child: StreamBuilder<QuerySnapshot>(
              //fonte de dados (coleção)
              stream: feedback.snapshots(),

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
                          var idFeedback =
                              snapshot.data!.docs[index].reference.id;
                          if (namePesquisa.isEmpty) {
                            return exibirItem(data, idUsuario, idFeedback);
                          }
                          if (data['avaliacao']
                              .toString()
                              .toLowerCase()
                              .startsWith(namePesquisa.toLowerCase())) {
                            return exibirItem(data, idUsuario, idFeedback);
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
    if (widget.tipoUsuario != 'Clientes') {
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
            'feedback',
            arguments: {
              'tipoUsuario': widget.tipoUsuario,
              'idPet': widget.idPet,
              'idAlimento': widget.idAlimento,
              'idFeedback': '',
              'stateAlimentacao': widget.stateAlimentacao,
              'stateFeedback': widget.stateFeedback,
            },
          );
        },
      );
    }
  }

  Widget exibirItem(item, String idUsuario, String idFeedback) {
    String avaliacao = item['avaliacao'];
    String observacao = item['observacao'];
    String quantidade = item['quantidade'];
    String rejeicao = item['rejeicao'];

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
        //leading: Image.asset(iconPet),
        title: Text(
          avaliacao,
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
              rejeicao,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              observacao,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        trailing: Text(
          quantidade,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: kPrimaryColor,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            'feedback',
            arguments: {
              'tipoUsuario': widget.tipoUsuario,
              'idPet': widget.idPet,
              'idAlimento': widget.idAlimento,
              'idFeedback': idFeedback,
              'stateAlimentacao': widget.stateAlimentacao,
              'stateFeedback': widget.stateFeedback,
            },
          );
        },
        onLongPress: () {
          dialog(idUsuario, idFeedback, context);
        },
      ),
    );
  }
}

Future<void> dialog(String idUsuario, String idFeedback, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir Feedback?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Você excluirá permanentemente o Feedback!'),
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
                await FeedbackClass().deleteFeedback(idFeedback);
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao Excluir o deleteFeedback"),
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
