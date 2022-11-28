import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutriaumigos/constants.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nutriaumigos/Models/auth.dart';

enum SingingCharacter { cliente, nutricionista }

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter? _character = SingingCharacter.cliente;

  //Regex
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  static final RegExp numberTelefoneExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  static final RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  //Mascaras
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final maskNumber = MaskTextInputFormatter(
      mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});
  final maskData = MaskTextInputFormatter(mask: "##/##/####");
  @override
  Widget build(BuildContext context) {
    var txtNome = TextEditingController();
    var txtEmail = TextEditingController();
    var txtSenha = TextEditingController();
    var txtTelefone = TextEditingController();
    var txtCpf = TextEditingController();
    var txtDataNascimento = TextEditingController();
    var txtCodigoNutricionista = TextEditingController();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                alignment: const Alignment(0.0, 1.15),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Logo.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Qual seu tipo de usuário?',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<SingingCharacter>(
                      title: const Text('Cliente'),
                      value: SingingCharacter.cliente,
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.all(0.0),
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: RadioListTile<SingingCharacter>(
                      title: const Text('Nutricionista'),
                      value: SingingCharacter.nutricionista,
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.all(0.0),
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: txtNome,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Digite seu Nome'
                    : (nameRegExp.hasMatch(value)
                        ? null
                        : 'Digite um nome válido!'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Preencha o campo de email!'
                    : (emailRegExp.hasMatch(value)
                        ? null
                        : 'Digite um email válido!'),
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
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de senha!';
                  } else if (value.length < 8) {
                    return 'Digite uma senha válida, maior que 8 caracteres!';
                  }
                  return null;
                }),
              ),
              TextFormField(
                controller: txtTelefone,
                keyboardType: TextInputType.number,
                inputFormatters: [maskNumber],
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                validator: ((value) {
                  final phone = value?.replaceAll(RegExp(r'\D+'), '');
                  if (phone == null || phone.isEmpty) {
                    return 'Preencha o campo de telefone!';
                  } else if (phone.length != 11 || phone[2] != '9') {
                    return 'Digite um telefone válido!';
                  }
                  return null;
                }),
              ),
              TextFormField(
                controller: txtDataNascimento,
                keyboardType: TextInputType.datetime,
                inputFormatters: [maskData],
                decoration: const InputDecoration(
                  labelText: "Data de Nascimento",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de data de nascimento';
                  }
                  return null;
                }),
              ),
              TextFormField(
                controller: txtCpf,
                keyboardType: TextInputType.number,
                inputFormatters: [maskCpf],
                decoration: const InputDecoration(
                  labelText: "CPF",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo de CPF';
                  } else if (!CPFValidator.isValid(value)) {
                    return 'Digite um CPF válido!';
                  }
                  return null;
                }),
              ),
              if (_character?.index == 1)
                TextFormField(
                  controller: txtCodigoNutricionista,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "CRMV",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: const TextStyle(fontSize: 20),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o campo de CRMV';
                    }
                    return null;
                  }),
                ),
              const SizedBox(
                height: 10,
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
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await Authent()
                              .createUserwithEmailAndPassword(
                                  txtNome.text,
                                  txtEmail.text,
                                  txtSenha.text,
                                  txtTelefone.text,
                                  txtDataNascimento.text,
                                  txtCpf.text,
                                  txtCodigoNutricionista.text ?? '',
                                  context)
                              .then(
                            (value) {
                              Navigator.pop(context);
                            },
                          );
                        } on FirebaseException catch (e) {
                          var msg = '';
                          if (e.code == 'email-already-in-use') {
                            msg = 'ERRO: O email informado já está em uso';
                          } else {
                            msg = 'ERRO: ${e.message}';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(msg),
                              duration: const Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        }
                        //criarConta(txtNome.text ,txtEmail.text, txtSenha.text, txtTelefone.text, txtDataNascimento.text, txtCpf.text, txtCodigoNutricionista.text ?? "", context);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text(
                    "Cancelar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: kPrimaryColor,
                  ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void criarConta(String nome, String email, String senha, String telefone,
      String data, String cpf, String crmv, context) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: senha);

    Map<String, dynamic> userInfoMap = {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'data': data,
      'cpf': cpf,
      'crmv': crmv,
    };

    if (userCredential != null) {
      DatabaseMethods().addUserInfoToDB(auth.currentUser!.uid, userInfoMap);
    }
  }

  void salvarUsuario(nome, email, senha, telefone, data, cpf, crmv, context) {
    String? usuarioID;
    if (_character?.index == 0) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      Map usuarios = new HashMap();
      usuarios.putIfAbsent("nome", nome);
      usuarios.putIfAbsent("telefone", telefone);

      usuarioID = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference documentReference =
          db.collection("Clientes").doc(usuarioID);
      documentReference.set(usuarios);
    } else {}
  }
}

class DatabaseMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserFromDB(String userId) async {
    return FirebaseFirestore.instance.collection("users").doc(userId).get();
  }
}
