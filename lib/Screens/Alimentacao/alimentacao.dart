import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/Screens/Animais/animais.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/alimentos.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage(
      {super.key,
      required this.tipoUsuario,
      required this.idAlimento,
      required this.idPet,
      required this.idDono,
      required this.stateAlimentacao,
      required this.stateFeedback});
  final idAlimento;
  final tipoUsuario;
  final idPet;
  final idDono;
  final stateAlimentacao;
  final stateFeedback;

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

List<String> items = [
  'Segunda-Feira',
  'Terça-Feira',
  'Quarta-Feira',
  'Quinta-Feira',
  'Sexta-Feira',
  'Sábado',
  'Domingo'
];
String? selectedItem = 'Segunda-Feira';

var txtNomeAlimento = TextEditingController();
var txtNomePet = TextEditingController();
var txtHorario = TextEditingController();
var txtQuantidade = TextEditingController();
var txtDescricao = TextEditingController();

var idDono;

final _formKey = GlobalKey<FormState>();

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.idAlimento != null && widget.idAlimento !="") {
      getAlimentosById(widget.idAlimento);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alimentos",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            clearCampos();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () async {
              clearCampos();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: Container(
        color: kPrimaryColor,
        padding: const EdgeInsets.only(
          top: 40,
          left: 40,
          right: 40,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Image.asset("assets/icons/alimento.png"),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Cadastro de Alimento",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: kPrimaryLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                            color: Colors.white)),
                  ),
                  value: selectedItem,
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(fontSize: 20)),
                          ))
                      .toList(),
                  onChanged: widget.tipoUsuario != 'Clientes'
                      ? (item) => setState(() => selectedItem = item)
                      : null,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtNomeAlimento,
                autofocus: true,
                enabled: widget.tipoUsuario != 'Clientes',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Nome do Alimento",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de Nome do Alimento';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtNomePet,
                autofocus: true,
                enabled: widget.tipoUsuario != 'Clientes',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Nome do Pet",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de Nome do Pet';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtHorario,
                autofocus: true,
                enabled: widget.tipoUsuario != 'Clientes',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Horário",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de Horario';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtQuantidade,
                autofocus: true,
                enabled: widget.tipoUsuario != 'Clientes',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Quantidade",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de Quantidade';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtDescricao,
                autofocus: true,
                enabled: widget.tipoUsuario != 'Clientes',
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Descrição",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de Descrição';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 40,
              ),
              if (widget.tipoUsuario != 'Clientes')
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Color.fromARGB(255, 238, 214, 3),
                        Color.fromARGB(255, 247, 225, 32),
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
                            "Cadastrar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              wordSpacing: 10,
                              color: Colors.black,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.idAlimento == null ||
                              widget.idAlimento == '') {
                            try {
                              await Alimentos()
                                  .createAlimento(
                                      widget.idPet,
                                      widget.idDono,
                                      selectedItem.toString(),
                                      txtNomeAlimento.text,
                                      txtNomePet.text,
                                      txtHorario.text,
                                      txtQuantidade.text,
                                      txtDescricao.text,
                                      context)
                                  .then(
                                (value) {
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
                          } else {
                            try {
                              await Alimentos()
                                  .updateAlimento(
                                      widget.idPet,
                                      widget.idDono,
                                      selectedItem.toString(),
                                      txtNomeAlimento.text,
                                      txtNomePet.text,
                                      txtHorario.text,
                                      txtQuantidade.text,
                                      txtDescricao.text,
                                      widget.idAlimento.toString(),
                                      context)
                                  .then(
                                (value) {
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Erro ao Atualizar o Animal"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          }
                          clearCampos();
                        }
                      },
                    ),
                  ),
                ),
              if (widget.tipoUsuario != 'Clientes')
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: TextButton(
                      child: const Text(
                        "Cancelar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kSecondColor),
                      ),
                      onPressed: () {
                        cleanCampos();
                        Navigator.pop(context, false);
                      }),
                ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getAlimentosById(String idAlimento) async {
  await FirebaseFirestore.instance
      .collection('alimentos')
      .doc(idAlimento)
      .get()
      .then((value) {
    txtNomeAlimento.text = value.get('nomeAlimento');
    txtNomePet.text = value.get('nomePet');
    txtHorario.text = value.get('horario');
    txtQuantidade.text = value.get('quantidade');
    txtDescricao.text = value.get('descricao');
    selectedItem = value.get('diaSemana');
  });
}

clearCampos(){
    txtNomeAlimento.text = '';
    txtNomePet.text = '';
    txtHorario.text = '';
    txtQuantidade.text = '';
    txtDescricao.text = '';
    selectedItem = 'Segunda-Feira';
}
