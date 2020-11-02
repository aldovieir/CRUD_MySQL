import 'package:estudo_mysql/products/add_products.dart';
import 'package:estudo_mysql/products/editi_products.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List list = List();
  Key key;
  @override
  void initState() {
    super.initState();
    getMysql();
  }

  Future getMysql() async {
    var settings = new ConnectionSettings(
        host: '104.131.182.54',
        port: 3306,
        user: 'silasrpg',
        password: 'savcjuni',
        db: 'teste');
    var conn = await MySqlConnection.connect(settings);

    var results = await conn.query('select * from produtos');
    //await conn.query('select id, nome, quantidade, preco from produtos');

    setState(() {
      list = results.toList();
    });

    return list;
  }

  dismissPerson(item) {
    if (list.contains(item)) {
      //_itemList is list of item shown in ListView
      setState(() {
        list.remove(item);
      });
    }
  }

  deletedMySql(id) async {
    var settings = new ConnectionSettings(
        host: '104.131.182.54',
        port: 3306,
        user: 'silasrpg',
        password: 'savcjuni',
        db: 'teste');
    var conn = await MySqlConnection.connect(settings);

    await conn.query('delete from produtos where id = $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: IconButton(
        onPressed: () {
          getMysql();
        },
        icon: Icon(Icons.reset_tv),
      ),
      appBar: AppBar(
        title: Text('Estudo MySql'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: (list.isEmpty || list == null) ? 0 : list.length,
          itemBuilder: (BuildContext context, int index) {
            if (list.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            final item = list[index]['id'].toString();
            return Dismissible(
              key: Key(item),
              direction: DismissDirection.horizontal,
              //onResize: () => deletedMySql(list[index]['id']),
              //   confirmDismiss: (direction) => deletedMySql(list[index]['id']),
              onDismissed: (direction) {
                dismissPerson(item);
                deletedMySql(list[index]['id']);

                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$item foi removido"),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              child: ListTile(
                  title: Text(list[index]['nome']),
                  subtitle: Text("Quantidade: " + list[index]['quantidade']),
                  trailing: Text("R\$ " + list[index]['preco']),
                  onLongPress: () => deletedMySql(list[index]['id']),
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProducts(
                          nome: list[index]['nome'],
                          id: list[index]['id'],
                          preco: list[index]['preco'],
                          quantidade: list[index]['quantidade'],
                        ),
                      ))),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(),
              ));
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
