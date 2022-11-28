import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/database.dart';
import 'package:nutriaumigos/Models/pets.dart';

class ListaAnimaisPage extends StatefulWidget {
  const ListaAnimaisPage(
      {super.key,
      required this.tipoUsuario,
      required this.stateAlimentacao,
      required this.stateFeedback,
      required this.idDono});
  final tipoUsuario;
  final stateAlimentacao;
  final stateFeedback;
  final idDono;

  @override
  State<ListaAnimaisPage> createState() => _ListaAnimaisPageState();
}

class _ListaAnimaisPageState extends State<ListaAnimaisPage> {
  String namePesquisa = '';
  var tipoUsuario;
  var pets;
  var nutricionista;
  String idUsuario = '';

  get kPrimaryColor => null;

  @override
  void initState() {
    super.initState();
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
    if (widget.tipoUsuario == 'Clientes') {
      pets = FirebaseFirestore.instance
          .collection('pets')
          .where('idDono', isEqualTo: idUsuario);
    } else {
      pets = FirebaseFirestore.instance
          .collection('pets')
          .where('idDono', isEqualTo: widget.idDono);
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
        title: Text("Pets"),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
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
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              //fonte de dados (coleção)
              stream: pets.snapshots(),

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
                          var idPet = snapshot.data!.docs[index].reference.id;
                          var idDono = data['idDono'];
                          if (namePesquisa.isEmpty) {
                            return exibirItem(data, idUsuario, idPet, idDono);
                          }
                          if (data['nome']
                              .toString()
                              .toLowerCase()
                              .startsWith(namePesquisa.toLowerCase())) {
                            return exibirItem(data, idUsuario, idPet, idDono);
                          }
                          return Container();
                        },
                        padding: EdgeInsets.all(20),
                      ),
                    );
                }
              },
            ),
          ],
        ),
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
            'animais',
            arguments: {
              'idPets': '',
              'tipoUsuario': widget.tipoUsuario,
            },
          );
        },
      );
    }
  }

  Widget exibirItem(item, String idUsuario, String idPet, String idDono) {
    String nomePet = item['nome'];
    String racaPet = item['raca'];
    String generoPet = item['sexo'];
    String pesoPet = item['peso'].toString();
    String tipoAnimal = item['tipo'];
    String iconDog = "assets/icons/dog.png";
    String iconCat = "assets/icons/cat.png";

    String iconPet =
        tipoAnimal.toString().toLowerCase() == 'cachorro' ? iconDog : iconCat;

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
        leading: Image.asset(iconPet),
        title: Text(
          nomePet,
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
              racaPet,
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
              generoPet,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pesoPet,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
          if (widget.tipoUsuario == 'Clientes' &&
              !widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'animais',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              !widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'animais',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario == 'Clientes' &&
              widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'listaAlimentos',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              widget.stateAlimentacao &&
              !widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'listaAlimentos',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario == 'Clientes' &&
              !widget.stateAlimentacao &&
              widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'listaAlimentos',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else if (widget.tipoUsuario != 'Clientes' &&
              !widget.stateAlimentacao &&
              widget.stateFeedback) {
            Navigator.pushNamed(
              context,
              'listaAlimentos',
              arguments: {
                'tipoUsuario': widget.tipoUsuario,
                'idPet': idPet,
                'idDono': idDono,
                'stateAlimentacao': widget.stateAlimentacao,
                'stateFeedback': widget.stateFeedback,
              },
            );
          } else {
            Navigator.pop(context);
          }
        },
        onLongPress: () {
          dialog(idUsuario, idPet, context);
        },
      ),
    );
  }
}

Future<void> dialog(String idUsuario, String idPet, context) {
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
                await Pets().deletePet(idPet);
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
