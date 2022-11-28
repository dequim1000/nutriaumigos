import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:nutriaumigos/Models/feedback.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage(
      {super.key,
      required this.tipoUsuario,
      required this.idPet,
      required this.idAlimento,
      required this.idFeedback,
      required this.stateAlimentacao,
      required this.stateFeedback});
  final tipoUsuario;
  final idPet;
  final idAlimento;
  final idFeedback;
  final stateAlimentacao;
  final stateFeedback;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

var txtNomeAlimento = TextEditingController();
var txtAvaliacao = TextEditingController();
var txtRejeicao = TextEditingController();
var txtQuantidade = TextEditingController();
var txtObservacao = TextEditingController();
var txtResposta = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _FeedbackPageState extends State<FeedbackPage> {
  List allFeedback = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idFeedback != null && widget.idFeedback != '') {
      getFeedbackById(widget.idFeedback);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            cleanCampos();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: Container(
        color: kPrimaryColor,
        padding: const EdgeInsets.only(
          top: 20,
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
                    icon: Image.asset("assets/icons/feedback_white.png"),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Cadastro de Feedback",
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
              TextFormField(
                controller: txtAvaliacao,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
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
                  labelText: "Avaliação",
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
                    return 'Preencha o campo de Avaliação';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtRejeicao,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
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
                  labelText: "Rejeição",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
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
                controller: txtQuantidade,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
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
                controller: txtObservacao,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtResposta,
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
                  labelText: "Resposta",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
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
                        if (widget.tipoUsuario == 'Clientes') {
                          if (widget.idFeedback == null ||
                              widget.idFeedback == '') {
                            try {
                              await FeedbackClass()
                                  .createFeedback(
                                      widget.idPet,
                                      widget.idAlimento,
                                      txtAvaliacao.text,
                                      txtRejeicao.text,
                                      txtQuantidade.text,
                                      txtObservacao.text,
                                      '',
                                      context)
                                  .then(
                                (value) {
                                  cleanCampos();
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Erro ao Cadastrar o Feedback"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          } else {
                            try {
                              await FeedbackClass()
                                  .updateFeedback(
                                      widget.idPet,
                                      widget.idAlimento,
                                      txtAvaliacao.text,
                                      txtRejeicao.text,
                                      txtQuantidade.text,
                                      txtObservacao.text,
                                      txtResposta.text == ''
                                          ? ''
                                          : txtResposta.text,
                                      widget.idFeedback,
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
                                  content: Text("Erro ao Atualizar o Feedback"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          if (widget.idFeedback != null ||
                              widget.idFeedback != '') {
                            try {
                              await FeedbackClass()
                                  .updateFeedback(
                                      widget.idPet,
                                      widget.idAlimento,
                                      txtAvaliacao.text,
                                      txtRejeicao.text,
                                      txtQuantidade.text,
                                      txtObservacao.text,
                                      txtResposta.text,
                                      widget.idFeedback,
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
                                  content: Text("Erro ao Atualizar o Feedback"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          }
                        }

                        //Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
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
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

cleanCampos() {
  txtAvaliacao.text = '';
  txtRejeicao.text = '';
  txtQuantidade.text = '';
  txtObservacao.text = '';
  txtResposta.text = '';
}

getFeedbackById(String idFeedback) async {
  await FirebaseFirestore.instance
      .collection('feedback')
      .doc(idFeedback)
      .get()
      .then((value) {
    txtAvaliacao.text = value.get('avaliacao');
    txtRejeicao.text = value.get('rejeicao');
    txtQuantidade.text = value.get('quantidade');
    txtObservacao.text = value.get('observacao');
    txtResposta.text = value.get('resposta');
  });
}
