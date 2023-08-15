// ignore: unused_import
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class PDFConverter {
  static Future<File?> convertTextToPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Text(text),
      );
    }));

    // Define the path where the PDF file will be saved
    final output =
        File('${await getApplicationDocumentsDirectory()}/output.pdf');

    // Save the PDF to the file
    await output.writeAsBytes(await pdf.save());

    return output;
  }
  
  static getApplicationDocumentsDirectory() {}
}
