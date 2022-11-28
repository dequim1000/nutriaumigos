import 'package:flutter/material.dart';
import 'package:nutriaumigos/constants.dart';

class InputMessageWidget extends StatelessWidget {
  const InputMessageWidget({
    Key? key,
    required this.messageEditingController,
    required this.handleSubmit,
  }) : super(key: key);

  final TextEditingController messageEditingController;
  final Function(String message) handleSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            Flexible(
                child: TextField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              controller: messageEditingController,
              cursorColor: kPrimaryColor,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.all(20.0),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Digite a Mensagem',
                hintStyle: TextStyle(color: Colors.black45),
                labelStyle: TextStyle(color: Colors.black45),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kSecondColor, width: 5),
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  gapPadding: 8.0,
                ),
              ),
            )),
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: kSecondColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () => handleSubmit(messageEditingController.text),
                icon: const Icon(
                  Icons.pets,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
