import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutriaumigos/constants.dart';

import '../../Models/message.dart';
import '../../Providers/chat_provider.dart';
import 'widgets/input_message.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.tipoUsuario, required this.idItem});
  final tipoUsuario;
  final idItem;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

String idUsuario = '';

class _ChatScreenState extends State<ChatScreen> {
  final ChatProvider chatProvider =
      ChatProvider(firebaseFirestore: FirebaseFirestore.instance);

  final TextEditingController messageEditingController =
      TextEditingController();

  List<QueryDocumentSnapshot> messageList = [];

  final ScrollController scrollController = ScrollController();

  currentUser(context) => ModalRoute.of(context)?.settings.arguments as String;

  void sendMessage(String message) {
    var tipo;
    if (widget.tipoUsuario == 'Clientes') {
      tipo = 'C';
      if (message.isNotEmpty) {
        messageEditingController.clear();
        chatProvider.sendMessage(
            message.trim(), widget.idItem, idUsuario, tipo);
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      tipo = 'N';
      if (message.isNotEmpty) {
        messageEditingController.clear();
        chatProvider.sendMessage(
            message.trim(), idUsuario, widget.idItem, tipo);
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    idUsuario = FirebaseAuth.instance.currentUser!.uid;
    var getMenssage;
    var tipo;
    if (widget.tipoUsuario == 'Clientes') {
      tipo = 'C';
      getMenssage = chatProvider.getMessageList(widget.idItem, idUsuario);
    } else {
      tipo = 'N';
      getMenssage = chatProvider.getMessageList(idUsuario, widget.idItem);
    }
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 152, 158, 0.73),
        elevation: 1,
        title: const Text('Chat', style: TextStyle(fontSize: 24)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getMenssage,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      messageList = snapshot.data!.docs;

                      if (messageList.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: messageList.length,
                            reverse: true,
                            controller: scrollController,
                            itemBuilder: (context, index) =>
                                _buildItem(index, messageList[index], tipo));
                      } else {
                        return const Center(
                          child: Text('Sem mensagens...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ),
              InputMessageWidget(
                messageEditingController: messageEditingController,
                handleSubmit: sendMessage,
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildItem(int index, DocumentSnapshot? documentSnapshot, String tipo) {
    if (documentSnapshot != null) {
      final chatMessage = MessageModel.fromDocument(documentSnapshot);
      final isMe = chatMessage.tipo == tipo;

      return MessageBubbleWidget(chatMessage: chatMessage, isMe: isMe);
    }
  }
}
