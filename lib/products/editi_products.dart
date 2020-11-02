import 'package:estudo_mysql/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class EditProducts extends StatelessWidget {
  final int id;
  final String nome;
  final String preco;
  final String quantidade;

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantitController = TextEditingController();

  EditProducts({Key key, this.nome, this.preco, this.quantidade, this.id})
      : super(key: key);

  Future updateMysql() async {
    var settings = new ConnectionSettings(
        host: '104.131.182.54',
        port: 3306,
        user: 'silasrpg',
        password: 'savcjuni',
        db: 'teste');

    var conn = await MySqlConnection.connect(settings);
    print(conn);
    var results = await conn.query(
      'UPDATE produtos SET nome = "${_nomeController.text}", preco = "${_precoController.text}", quantidade = "${_quantitController.text}" WHERE id =$id;',
    );

    //    ["$_nomeController", "$_precoController", "$_quantitController"]);
    //await conn.query('select id, nome, quantidade, preco from produtos');
    return results;
  }

  @override
  Widget build(BuildContext context) {
    _nomeController.text = nome ?? "";
    _precoController.text = preco ?? "";
    _quantitController.text = quantidade ?? "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          },
        ),
        title: Text('Novo produto'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                updateMysql();
                Future.delayed(Duration(seconds: 3));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                controller: _nomeController,
//onChanged: (newValue) => modelItems.nome = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                controller: _precoController,
//onChanged: (newValue) => modelItems.preco = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                controller: _quantitController,
                textInputAction: TextInputAction.done,
                //  onChanged: (newValue) => modelItems.imagem = newValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
