import 'package:flutter/material.dart';
import 'package:wemoga/helpers/empresa_helper.dart';
import 'package:wemoga/models/empresa_model.dart';
import 'package:wemoga/ui/empresa_detail.dart';

class EmpresaList extends StatefulWidget {
  @override
  _EmpresaListState createState() => _EmpresaListState();
}

class _EmpresaListState extends State<EmpresaList> {
  EmpresaHelper helper = EmpresaHelper();

  List<Empresa> empresas = List();

  @override
  void initState() {
    super.initState();

    _getAllEmpresas();
  }

  Widget _empresaCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                empresas[index].name ?? "",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                empresas[index].phone ?? "",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showEmpresaPage(empresa: empresas[index]);
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
        title: Text("TESTE WEMOGA"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEmpresaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: empresas.length,
        itemBuilder: (context, index) {
          return _empresaCard(context, index);
        },
      ),
    );
  }

  void _showEmpresaPage({Empresa empresa}) async {
    final recEmpresa = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmpresaDetail(
              empresa: empresa,
            )));
    if (recEmpresa != null) {
      if (empresa != null) {
        await helper.updateEmpresa(recEmpresa);
      } else {
        await helper.saveEmpresa(recEmpresa);
      }
      _getAllEmpresas();
    }
  }

  void _getAllEmpresas() {
    helper.getAllEmpresa().then((list) {
      setState(() {
        empresas = list;
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
                  Text("Deseja Excluir?", style: TextStyle(color: Colors.black, fontSize: 20.0),),
                  FlatButton(
                    child: Text("Excluir",
                      style: TextStyle(color: Colors.blue, fontSize: 17.0),),
                    onPressed: (){
                      helper.deleteEmpresa(empresas[index].id);
                      setState(() {
                        empresas.removeAt(index);
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
