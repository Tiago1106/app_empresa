import 'package:flutter/material.dart';
import 'package:wemoga/ui/empresa_list.dart';
import 'package:wemoga/ui/funcionario_detail.dart';

void main() async {
  runApp(MaterialApp(
    home: EmpresaList(),
    debugShowCheckedModeBanner: false,
  ));
}