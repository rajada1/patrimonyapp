import 'package:loading_overlay/loading_overlay.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_patrimony/models/email_model.dart';

import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controllerObservacao = TextEditingController();
  TextEditingController _controllerDigBarcode = TextEditingController();

  void _cardAlterar() {
    Center(
      child: Card(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Coloque a observação'),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'exemplo: "Alterar alterar para Remesa',
            ),
          ),
        ],
      )),
    );
  }

  String _textresult = '';
  var email = Email('patrimonio.anp@gmail.com', 'I@sd12345');

  void _sendEmail() async {
    String _observacao = _controllerObservacao.text;
    bool result = await email.sendMessage(

        //  Envio de Email
        // Mensagem
        '$_nome\n'
            ' $_departamento\n'
            '$_codigo\n\n'
            'Observação do Solicitante:  $_observacao',
        // Email
        'patrimonio.anp@gmail.com',
        //Assunto
        'Patrimony APP');
    setState(() {
      _textresult = result ? 'Enviado.' : 'Não Enviado';
    });
  }

  String barcode = "";
  String _departamento = "";
  String _nome = "";
  String _codigo = "";
  bool _isLoading = false;

  @override
  FlutterToast flutterToast;
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Scanner'),
            ],
          ),
          backgroundColor: Color.fromRGBO(31, 45, 68, 1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: RaisedButton(
                onPressed: barcodeScanning,
                child: Text('Escanear código de barra'),
              ),
              // padding: EdgeInsets.all(8),
            ),
            // RaisedButton(
            //   onPressed: _showToast,
            //   child: Text('TODOO'),
            // ),
            RaisedButton(
              onPressed: _digitarBarcode,
              child: Text('Digitar código de barra'),
            ),

            RaisedButton(
              onPressed: () {
                if (barcode.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('ESCANEIE OU DIGITE PRIMEIRO'),
                        );
                      });
                } else {
                  _showDialog();
                }
              },
              child: Text('Solicitar alteração'),
            ),

            // FloatingActionButton(
            //   onPressed: _sendEmail,
            //   tooltip: 'Send Email',
            //   child: Icon(Icons.email),
            // ),
            Padding(
              padding: EdgeInsets.all(8),
            ),

            Text(
              _nome,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue),
            ),
            Text(
              _departamento,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue),
            ),
            Text(
              _codigo,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(31, 45, 68, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            title: Text(
              'Historico',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            title: Text(
              'Configurações',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }

  // Method for scanning barcode....
  Future barcodeScanning() async {
//imageSelectorGallery();

    try {
      // ignore: unnecessary_cast
      String barcode = (await BarcodeScanner.scan()) as String;

      setState(
        () => this.barcode = barcode,
      );
      _recuperarCode();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future _recuperarCode() async {
    List barcodesplit = barcode.split("");
    String entidade =
        barcodesplit[0] + barcodesplit[1] + barcodesplit[2] + barcodesplit[3];
    String c = barcodesplit[4] +
        barcodesplit[5] +
        barcodesplit[6] +
        barcodesplit[7] +
        barcodesplit[8] +
        barcodesplit[9];

    int code = int.parse(c);

    String url = "http://10.16.0.13:5000/read/$entidade/$code";

    http.Response response;

    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);
    String departamento = retorno["departamento"];
    String nome = retorno["nome"];
    String codigo = retorno["codigo"];

    setState(() {
      _departamento = " Departamento: $departamento ";
      _nome = "Item: $nome ";
      _codigo = "Código: $codigo";
    });
  }

  Future<void> _digitarBarcode() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Digite o Código de Barra'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: _controllerDigBarcode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exemplo: 1611002192',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  barcode = _controllerDigBarcode.text;
                  setState(
                    () => this.barcode = barcode,
                  );
                  _recuperarCode();
                  _controllerDigBarcode.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Adicione as observações'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: _controllerObservacao,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Exemplo: Alterar para remesa.',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  print(_textresult);
                  _sendEmail();
                  _controllerObservacao.clear();
                  Navigator.of(context).pop();
                  _showToastEnviado();
                },
                child: Text('Enviar Email'),
              ),
            ],
          );
        });
  }

  _showToastEnviado() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromRGBO(105, 105, 105, 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Solicitação Enviada"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
