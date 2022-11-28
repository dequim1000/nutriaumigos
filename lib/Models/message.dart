import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String nutri;
  String message;
  String cliente;
  String tipo;
  Timestamp timestamp;

  MessageModel(
      {required this.nutri,
      required this.cliente,
      required this.tipo,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'nutri': nutri,
      'cliente': cliente,
      'tipo': tipo,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromDocument(DocumentSnapshot documentSnapshot) {
    String nutri = documentSnapshot.get('nutri');
    String cliente = documentSnapshot.get('cliente');
    String tipo = documentSnapshot.get('tipo');
    String message = documentSnapshot.get('message');
    Timestamp timestamp = documentSnapshot.get('timestamp');

    return MessageModel(
        nutri: nutri,
        cliente: cliente,
        tipo: tipo,
        message: message,
        timestamp: timestamp);
  }
}
