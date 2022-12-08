import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/database.dart';

import '../../Models/usuarios.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage(
      {super.key,
      required this.tipoUsuario,
      required this.stateAlimentacao,
      required this.stateFeedback,
      required this.statePets});
  final tipoUsuario;
  final stateAlimentacao;
  final stateFeedback;
  final statePets;
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  String namePesquisa = '';

  get kPrimaryColor => null;

  var usuarios;
  var clientesToNutricionista;
  var nutricionista;
  List allData = [];
  String idUsuario = '';
  var listaAux;
  List<String> lista = [];

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("usernutri");

  Future<void> getDataCliente() async {
    QuerySnapshot querySnapshot = await _collectionReference
        .where("idClientes", isEqualTo: idUsuario)
        .get();

    setState(() {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> getDataNutri() async {
    QuerySnapshot querySnapshot =
        await _collectionReference.where("idNutri", isEqualTo: idUsuario).get();
    setState(() {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.tipoUsuario == 'Clientes') {
      Timer(Duration(seconds: 1), () => getDataCliente());

      usuarios = FirebaseFirestore.instance
          .collection('user')
          .where('crmv', isNotEqualTo: '');
    } else {
      Timer(Duration(seconds: 1), () => getDataNutri());

      usuarios = FirebaseFirestore.instance
          .collection('user')
          .where('crmv', isEqualTo: '');
    }
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    String usuario = '';

    if (widget.tipoUsuario == 'Clientes') {
      int index;
      listaAux = [];
      for (index = 0; index <= allData.length - 1; index++) {
        listaAux = allData[index] as Map<String, dynamic>;

        lista.add(listaAux['idNutri']);
      }
      usuario = 'Nutricionistas';
    } else {
      usuario = 'Clientes';

      if (allData.isNotEmpty) {
        //var index = allData.length;
        int index;
        listaAux = [];
        for (index = 0; index <= allData.length - 1; index++) {
          listaAux = allData[index] as Map<String, dynamic>;

          lista.add(listaAux['idClientes']);
        }
      }
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
      appBar: AppBar(
        title: Text(usuario),
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
          //Mostrar Lista de Nutricionistas Disponiveis
          if (allData.isEmpty && widget.tipoUsuario == 'Clientes')
            Container(
              child: StreamBuilder<QuerySnapshot>(
                //fonte de dados (coleção)
                stream: usuarios.snapshots(),

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
                            var idNutri =
                                snapshot.data!.docs[index].reference.id;
                            if (namePesquisa.isEmpty) {
                              return exibirItem(data, idUsuario, idNutri);
                            }
                            if (namePesquisa != '' &&
                                data['nome']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(namePesquisa.toLowerCase())) {
                              if (lista.contains(idNutri)) {
                                return exibirItem(data, idUsuario, idNutri);
                              }
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
          if (allData.isNotEmpty && widget.tipoUsuario == 'Clientes')
            //Listar o Nutricionista Vinculado
            Container(
              child: StreamBuilder<QuerySnapshot>(
                //fonte de dados (coleção)
                stream: usuarios.snapshots(),

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
                            var idNutri =
                                snapshot.data!.docs[index].reference.id;
                            if (namePesquisa.isEmpty) {
                              if (lista.contains(idNutri)) {
                                return exibirItem(data, idUsuario, idNutri);
                              }
                            }
                            if (namePesquisa != '' &&
                                data['nome']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(namePesquisa.toLowerCase())) {
                              if (lista.contains(idNutri)) {
                                return exibirItem(data, idUsuario, idNutri);
                              }
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
          //Mostrar Usuarios Cadastrados daquele nutri
          if (allData.isNotEmpty && widget.tipoUsuario != 'Clientes')
            Container(
              child: StreamBuilder<QuerySnapshot>(
                //fonte de dados (coleção)
                stream: usuarios.snapshots(),

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
                            var idCliente =
                                snapshot.data!.docs[index].reference.id;
                            if (namePesquisa.isEmpty) {
                              if (lista.contains(idCliente)) {
                                return exibirItem(data, idUsuario, idCliente);
                              }
                            }
                            if (namePesquisa != '' &&
                                data['nome']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(namePesquisa.toLowerCase())) {
                              if (lista.contains(idCliente)) {
                                return exibirItem(data, idUsuario, idCliente);
                              }
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
          if (allData.isEmpty && widget.tipoUsuario != 'Clientes')
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              child: const Center(
                child: Text(
                  "Você não possui nenhum cliente vinculado!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget exibirItem(item, String idUsuario, String idItem) {
    String nomeUsuario = item['nome'];
    String descricao = item['crmv'] == '' ? 'Cliente' : item['crmv'];

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
        leading: const Icon(
          Icons.account_circle,
          size: 56,
          color: Colors.grey,
        ),
        title: Text(
          nomeUsuario,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          descricao,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Image.asset(
                'assets/icons/osso-de-cao.png',
                height: 40,
                width: 40,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        onTap: () {
          if (widget.tipoUsuario == 'Clientes' && allData.isEmpty) {
            dialog(idUsuario, idItem, context);
          } else if (widget.tipoUsuario == 'Clientes' && allData.isNotEmpty) {
            Navigator.pushNamed(context, '/chat', arguments: {
              'idItem': idItem,
              'tipoUsuario': widget.tipoUsuario
            });
          } else if (widget.tipoUsuario != 'Clientes' &&
              allData.isNotEmpty &&
              widget.statePets) {
            Navigator.pushNamed(context, '/chat', arguments: {
              'idItem': idItem,
              'tipoUsuario': widget.tipoUsuario
            });
          } else if (widget.tipoUsuario != 'Clientes' &&
              allData.isNotEmpty &&
              !widget.statePets) {
            Navigator.pushNamed(context, 'listaAnimais', arguments: {
              'tipoUsuario': widget.tipoUsuario,
              'idDono': idItem,
              'stateAlimentacao': widget.stateAlimentacao,
              'stateFeedback': widget.stateFeedback,
            });
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

Future<void> dialog(String idCliente, String idNutri, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Vincular Nutricionista?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Ao vincular o nutricionista, ele se tornará seu nutricionista responsável!'),
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
            child: const Text('Vincular'),
            onPressed: () async {
              try {
                await Usuarios().createUsers(idCliente, idNutri, context).then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Nutricionista vinculado com sucesso!"),
                        duration: Duration(
                          seconds: 2,
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao Cadastrar o Animal"),
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
