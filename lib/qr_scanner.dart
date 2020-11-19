import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'utils/database_helper.dart';
import 'utils/figuras.dart';
import 'dart:typed_data';
import 'result_scan.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String scanResult = '';
  DatabaseHelper databaseHelper = DatabaseHelper();
  String nombre = '';
  String descripcion = '';
  Uint8List imagen = null;
  String audio;
  bool isCorrect = true;

  Future scanQRCode() async {
    String cameraScanResult = await scanner.scan(); //abre escaner y coloca resultado en cameraScanResult
    print("CAMERA RESULT "+cameraScanResult);
    Future<Figuras> todoListFuture = databaseHelper.getInfo(cameraScanResult); //trae info de la base de datos

    todoListFuture.then((figura) {
      setState(() { //setea las variables con los datos de la base de datos
        this.scanResult = cameraScanResult;
        this.nombre = figura.nombre;
        this.descripcion = figura.descripcion;
        this.imagen = figura.imagen;
        this.audio = "audio/"+cameraScanResult+"ES.mp3"; //protocolo para intercambio directo entre idiomas
      });

      if(this.nombre != "null"){ //pasa a la vista de resultado, si hubo matck con la base de datos, y le envía los datos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScan(nombre, descripcion, imagen, audio)),
        );
        this.isCorrect = true;
      }else{
        this.isCorrect = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //vista del QrScanner
    return Scaffold(
      body:  Builder(
          builder: (context) {
            return Container(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //AVISO
                (!isCorrect) ?
                Container(
                  margin: EdgeInsets.only(
                      top: 16.0,
                      left: 20.0,
                      right: 20.0
                  ),
                  child: Text(
                      "El QR escaneado no forma parte de nuestra Base de Datos. ¡Vuelve a intentar!",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Lato',
                          color: Colors.redAccent
                      ),
                      textAlign: TextAlign.center
                  ),
                ) :
                Text(""),

                //TÍTULO
                Container(
                  margin: EdgeInsets.only(
                      top: 56.0,
                      bottom: 20.0
                  ),
                  child: Text(
                      "¡Escanea los códigos!",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center
                  ),
                ),

                //TEXTO DE INDICACIONES
                Container(
                  margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0
                  ),
                  child: Text(
                      "Con el bóton Escanear QR tendrás acceso al escáner, acerca tu móvil a los códigos y disfruta de la Guía! Para volver a escanear usa la flecha de retroceso.",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Lato',
                          color: Colors.black38
                      ),
                      textAlign: TextAlign.center
                  ),
                ),

                //IMÁGEN DE QR
                Container(
                    height: 128.0,
                    width: 128.0,
                    margin: EdgeInsets.only(
                        top: 32.0,
                        bottom: 32.0
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/img/qr_code.png")
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle,
                        boxShadow: <BoxShadow> [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 7.0)
                          )
                        ]

                    )
                ),

                //BOTÓN PARA ABRIR EL ESCANER
                InkWell(
                  onTap: scanQRCode,
                  child: Container(
                    height: 50.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff2F5233),
                    ),
                    child: Center(
                      child: Text(
                        "Escanear QR",
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 18.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
          }
      ),
    );
  }

}


