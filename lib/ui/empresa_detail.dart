import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemoga/helpers/empresa_helper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wemoga/models/empresa_model.dart';
import 'package:wemoga/ui/funcionario_list.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

EmpresaHelper helper = EmpresaHelper();

class EmpresaDetail extends StatefulWidget {
  final Empresa empresa;

  EmpresaDetail({this.empresa});

  @override
  _EmpresaDetailState createState() => _EmpresaDetailState();
}

class _EmpresaDetailState extends State<EmpresaDetail> {
  final _nameController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _ncasaController = TextEditingController();
  final _complementoController = TextEditingController();
  final _phoneController = TextEditingController();

  var phoneMask = new MaskTextInputFormatter(mask: '(##)#####-####', filter: { "#": RegExp(r'[0-9]') });

  final _nameFocus = FocusNode();

  bool _empresaEdited = false;

  Empresa _editedEmpresa;

  @override
  void initState() {
    super.initState();

    if (widget.empresa == null) {
      _editedEmpresa = Empresa();
    } else {
      _editedEmpresa = Empresa.fromMap(widget.empresa.toMap());

      _nameController.text = _editedEmpresa.name;
      _cepController.text = _editedEmpresa.cep;
      _ruaController.text = _editedEmpresa.rua;
      _bairroController.text = _editedEmpresa.bairro;
      _cidadeController.text = _editedEmpresa.cidade;
      _estadoController.text = _editedEmpresa.estado;
      _ncasaController.text = _editedEmpresa.ncasa;
      _complementoController.text = _editedEmpresa.complemento;
      _phoneController.text = _editedEmpresa.phone;
    }
  }


  /*onPressed: () {
  if (_editedEmpresa.name != null && _editedEmpresa.name.isNotEmpty) {
  Navigator.pop(context, _editedEmpresa);
  } else {
  FocusScope.of(context).requestFocus(_nameFocus);
  }*/

  // Edição da empresa
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(_editedEmpresa.name ?? "Nova Empresa"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _empresaEdited = true;
                  setState(() {
                    _editedEmpresa.name = text;
                  });
                },
              ),
              TextField(
                controller: _cepController,
                decoration: InputDecoration(labelText: "CEP"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.cep = text;
                },
              ),
              TextField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: "Rua"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.rua = text;
                },
              ),
              TextField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: "Bairro"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.bairro = text;
                },
              ),
              TextField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: "Cidade"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.cidade = text;
                },
              ),
              TextField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: "Estado"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.estado = text;
                },
              ),
              TextField(
                controller: _ncasaController,
                decoration: InputDecoration(labelText: "Numero Casa"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.ncasa = text;
                },
              ),
              TextField(
                controller: _complementoController,
                decoration: InputDecoration(labelText: "Complemento"),
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.complemento = text;
                },
              ),
              TextField(inputFormatters: [phoneMask],
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  _empresaEdited = true;
                  _editedEmpresa.phone = text;
                },)
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.blue,
          closeManually: true,
          child: Icon(Icons.menu),
          children: [
            SpeedDialChild(
                child: Icon(Icons.save),
                label: "Salvar",
                backgroundColor: Colors.blue,
                onTap: () {
                  if (_editedEmpresa.name != null &&
                      _editedEmpresa.name.isNotEmpty) {
                    Navigator.pop(context, _editedEmpresa);
                  } else {
                    FocusScope.of(context).requestFocus(_nameFocus);
                  }
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.person),
                label: "Funcionários",
                backgroundColor: Colors.blue,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FuncionarioList(
                      idEmpresa: widget.empresa.id,
                    ))
                  );
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.close),
                label: "Voltar",
                backgroundColor: Colors.blue,
                onTap: (){
                  Navigator.pop(context);
                }
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_empresaEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else{
      return Future.value(true);
    }
  }
}


