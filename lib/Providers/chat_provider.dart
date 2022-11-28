import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/message.dart';

class ChatProvider {
  final FirebaseFirestore firebaseFirestore;

  ChatProvider({required this.firebaseFirestore});

  Stream<QuerySnapshot> getMessageList(String nutri, String cliente) {
    return firebaseFirestore
        .collection('messages')
        .where('nutri', isEqualTo: nutri)
        .where('cliente', isEqualTo: cliente)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void sendMessage(String message, String nutri, String cliente, String tipo) {
    MessageModel chatMessages = MessageModel(
      nutri: nutri,
      cliente: cliente,
      tipo: tipo,
      timestamp: Timestamp.now(),
      message: message,
    );

    firebaseFirestore.collection('messages').add(chatMessages.toJson());
  }
}
