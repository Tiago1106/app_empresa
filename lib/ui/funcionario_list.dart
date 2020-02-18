import 'package:flutter/material.dart';
import 'package:wemoga/helpers/funcionario_helper.dart';
import 'package:wemoga/models/funcionario_model.dart';
import 'package:wemoga/ui/funcionario_detail.dart';

class FuncionarioList extends StatefulWidget {
  final int idEmpresa;

  FuncionarioList({this.idEmpresa});

  @override
  _FuncionarioListState createState() => _FuncionarioListState();
}

class _FuncionarioListState extends State<FuncionarioList> {
  FuncionarioHelper helper = FuncionarioHelper();

  List<Funcionario> func = List();

  @override
  void initState() {
    super.initState();

    _getAllFuncionarios();
  }

  Widget _funcionarioCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                func[index].nameFunc ?? "",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                func[index].cargo ?? "",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showFuncionarioPage(funcionario: func[index]);
      },
      onLongPress: (){
        _delete(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FUNCIONÁRIOS"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFuncionarioPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: func.length,
        itemBuilder: (context, index) {
          return _funcionarioCard(context, index);
        },
      ),
    );
  }

  void _showFuncionarioPage({Funcionario funcionario}) async {
    final recFuncionario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FuncionarioDetail(
              funcionario: funcionario, idEmpresa: widget.idEmpresa,
            )));
    if (recFuncionario != null) {
      if (funcionario != null) {
        await helper.updateFuncionario(recFuncionario);
      } else {
        await helper.saveFuncionario(recFuncionario);
      }
      _getAllFuncionarios();
    }
  }

  void _getAllFuncionarios() {
    helper.getAllFuncEmpresa(widget.idEmpresa).then((list) {
      setState(() {
        func = list;
      });
    });
  }

  void _delete(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Deseja Excluir?", style: TextStyle(color: Colors.black, fontSize: 20.0)),
                  FlatButton(
                    child: Text("Excluir",
                      style: TextStyle(color: Colors.blue, fontSize: 17.0),),
                    onPressed: (){
                      helper.deleteFuncionario(func[index].idFunc);
                      setState(() {
                        func.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("Cencelar",
                      style: TextStyle(color: Colors.blue, fontSize: 17.0),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
