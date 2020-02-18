import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:wemoga/models/funcionario_model.dart';

class FuncionarioDetail extends StatefulWidget {
  final Funcionario funcionario;
  final int idEmpresa;

  FuncionarioDetail({this.funcionario, this.idEmpresa});

  @override
  _FuncionarioDetailState createState() => _FuncionarioDetailState();
}

class _FuncionarioDetailState extends State<FuncionarioDetail> {
  final _nameFuncController = TextEditingController();
  final _salController = new MoneyMaskedTextController(leftSymbol: 'R\$ ');

  final _nameFuncFocus = FocusNode();

  bool _funcionarioEdited = false;

  Funcionario _editedFunc;

  @override
  void initState() {
    super.initState();

    print(widget.idEmpresa);
    if (widget.funcionario == null) {
      _editedFunc = Funcionario();
      _editedFunc.idEmpresa = widget.idEmpresa;
    } else {
      _editedFunc = Funcionario.fromMap(widget.funcionario.toMap());

      _nameFuncController.text = _editedFunc.nameFunc;
      _salController.text = integerToMoney(_editedFunc.salario*10);
      _selectedProf = _editedFunc.cargo;
    }
  }

  String integerToMoney(int value) {
    return (value/100).toString();
  }

  int moneyToInteger(String text) {
    return int.parse(text
        .replaceAll("R\$ ", "")
        .replaceAll(".", "")
        .replaceAll(",", ""));
  }

  List<String> _prof = ['PROGRAMADOR', 'DESIGNER', 'ADMINISTRAÇÃO'];
  String _selectedProf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editedFunc.nameFunc ?? "Novo Funcionario"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editedFunc.nameFunc != null &&
              _editedFunc.nameFunc.isNotEmpty) {
            Navigator.pop(context, _editedFunc);
          } else {
            FocusScope.of(context).requestFocus(_nameFuncFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //NOME FUNCIONARIO
            TextField(
              controller: _nameFuncController,
              focusNode: _nameFuncFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _funcionarioEdited = true;
                setState(() {
                  _editedFunc.nameFunc = text;
                });
              },
            ),
            TextField(
              controller: _salController,
              decoration: InputDecoration(labelText: "Salário"),
              onChanged: (text) {
                _funcionarioEdited = true;
                _editedFunc.salario = moneyToInteger(text);
              },
            ),
            DropdownButton(
              hint: Text('Cargo/Profissão'), // Not necessary for Option 1
              value: _selectedProf,
              onChanged: (newValue) {
                setState(() {
                  _selectedProf= newValue;
                  _funcionarioEdited = true;
                  _editedFunc.cargo = _selectedProf;
                });
              },
              items: _prof.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
