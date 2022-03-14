import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {

  final String title;
  final String content;

  const BlurryDialog(this.title, this.content, {Key? key}) : super(key: key);
  final TextStyle textStyle = const TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
      title: Text(title,style: textStyle,),
      content: Text(content, style: textStyle,),
      actions: <Widget>[
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      ));
  }
}