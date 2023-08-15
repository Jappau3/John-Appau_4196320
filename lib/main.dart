import 'package:flutter/material.dart';
import 'splashscreen.dart';


void main() {
  runApp(const TalkPDF());
}

class TalkPDF extends StatefulWidget {
  const TalkPDF({super.key});

  @override
  State<TalkPDF> createState() => _TalkPDFState();
}

class _TalkPDFState extends State<TalkPDF> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       debugShowCheckedModeBanner: false,
      home:Splashscreen(),
    );
  }
}