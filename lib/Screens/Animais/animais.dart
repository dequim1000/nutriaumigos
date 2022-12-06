import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriaumigos/constants.dart';

import '../../Models/pets.dart';

class AnimaisPage extends StatefulWidget {
  const AnimaisPage(
      {super.key, required this.idPet, required this.tipoUsuario});
  final idPet;
  final tipoUsuario;

  @override
  State<AnimaisPage> createState() => _AnimaisPageState();
}

var txtNomeAnimal = TextEditingController();
var txtTipo = TextEditingController();
var txtRaca = TextEditingController();
var txtCor = TextEditingController();
var txtIdade = TextEditingController();
var txtAlergias = TextEditingController();
var txtPeso = TextEditingController();
var txtSexo = TextEditingController();
var txtRejeicao = TextEditingController();
var txtProblemas = TextEditingController();
var txtObservacao = TextEditingController();
var txtDescricao = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _AnimaisPageState extends State<AnimaisPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.idPet != null && widget.idPet != '') {
      getPetById(widget.idPet);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pets",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            cleanCampos();
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
        color: kPrimaryColor,
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Image.asset("assets/icons/pet.png"),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Cadastro de Animais",
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
                controller: txtNomeAnimal,
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
                  labelText: "Nome do Animal",
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
                    return 'Preencha o campo de Nome do Animal';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtTipo,
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
                  labelText: "Tipo Ex:(Cachorro,Gato...)",
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
                    return 'Preencha o campo de Tipo do Animal';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtRaca,
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
                  labelText: "Raça",
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
                    return 'Preencha o campo de Raça';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtCor,
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
                  labelText: "Cor",
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
                    return 'Preencha o campo de Cor';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtSexo,
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
                  labelText: "Sexo",
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
                    return 'Preencha o campo de Sexo';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtIdade,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
                keyboardType: TextInputType.number,
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
                  labelText: "Idade",
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
                    return 'Preencha o campo de Idade do Animal';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtPeso,
                autofocus: true,
                enabled: widget.tipoUsuario == 'Clientes',
                keyboardType: TextInputType.number,
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
                  labelText: "Peso (Kg)",
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
                    return 'Preencha o campo de Peso';
                  }
                  return null;
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtAlergias,
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
                  labelText: "Alergia(s)",
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
                  labelText: "Possui alguma Rejeição?",
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
                controller: txtProblemas,
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
                  labelText: "Problemas",
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
                  labelText: "Observações",
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
                controller: txtDescricao,
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
                height: 40,
              ),
              if (widget.tipoUsuario == 'Clientes')
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
                          if (widget.idPet == null || widget.idPet == '') {
                            try {
                              await Pets()
                                  .createPets(
                                      txtNomeAnimal.text,
                                      txtTipo.text,
                                      txtRaca.text,
                                      txtCor.text,
                                      txtSexo.text,
                                      double.parse(txtIdade.text),
                                      double.parse(txtPeso.text),
                                      txtAlergias.text == '' ? 'Nenhuma': txtAlergias.text,
                                      txtRejeicao.text == '' ? 'Nenhuma': txtRejeicao.text,
                                      txtProblemas.text == '' ? 'Nenhuma': txtProblemas.text,
                                      txtObservacao.text == '' ? 'Nenhuma': txtObservacao.text,
                                      txtDescricao.text == '' ? 'Nenhuma': txtDescricao.text,
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
                                  content: Text("Erro ao Cadastrar o Animal"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          } else {
                            try {
                              await Pets()
                                  .updatePets(
                                      txtNomeAnimal.text,
                                      txtTipo.text,
                                      txtRaca.text,
                                      txtCor.text,
                                      txtSexo.text,
                                      double.parse(txtIdade.text),
                                      double.parse(txtPeso.text),
                                      txtAlergias.text == '' ? 'Nenhuma': txtAlergias.text,
                                      txtRejeicao.text == '' ? 'Nenhuma': txtRejeicao.text,
                                      txtProblemas.text == '' ? 'Nenhuma': txtProblemas.text,
                                      txtObservacao.text == '' ? 'Nenhuma': txtObservacao.text,
                                      txtDescricao.text == '' ? 'Nenhuma': txtDescricao.text,
                                      widget.idPet.toString(),
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
                                  content: Text("Erro ao Atualizar o Animal"),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              if (widget.tipoUsuario == 'Clientes')
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

getPetById(String idPet) async {
  await FirebaseFirestore.instance
      .collection('pets')
      .doc(idPet)
      .get()
      .then((value) {
    txtNomeAnimal.text = value.get('nome');
    txtTipo.text = value.get('tipo');
    txtRaca.text = value.get('raca');
    txtCor.text = value.get('cor');
    txtIdade.text = value.get('idade').toString();
    txtAlergias.text = value.get('alergia');
    txtPeso.text = value.get('peso').toString();
    txtSexo.text = value.get('sexo');
    txtRejeicao.text = value.get('rejeicao');
    txtProblemas.text = value.get('problemas');
    txtObservacao.text = value.get('observacoes');
    txtDescricao.text = value.get('descricao');
  });
}

cleanCampos() {
  txtNomeAnimal.text = '';
  txtTipo.text = '';
  txtRaca.text = '';
  txtCor.text = '';
  txtSexo.text = '';
  txtIdade.text = '';
  txtPeso.text = '';
  txtAlergias.text = '';
  txtRejeicao.text = '';
  txtProblemas.text = '';
  txtObservacao.text = '';
  txtDescricao.text = '';
}
