import 'package:estudo_mysql/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class AddProduct extends StatelessWidget {
  final _nameController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantitController = TextEditingController();

  Future getMysql() async {
    var settings = new ConnectionSettings(
        host: '104.131.182.54',
        port: 3306,
        user: 'silasrpg',
        password: 'savcjuni',
        db: 'teste');

    var conn = await MySqlConnection.connect(settings);

    var results = await conn.query(
      'INSERT INTO produtos (id , nome, quantidade, preco) VALUES  (null , "${_nameController.text}", "${_precoController.text}", "${_quantitController.text}");',
    );

    return results;
  }

  @override
  Widget build(BuildContext context) {
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
                getMysql();
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
                controller: _nameController,
//onChanged: (newValue) => modelItems.nome = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.next,
                controller: _precoController,
//onChanged: (newValue) => modelItems._preco = newValue,
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
