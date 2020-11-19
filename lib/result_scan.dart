import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class ResultScan extends StatefulWidget {
  String nombre = '';
  String descripcion = '';
  Uint8List imagen = null;
  String audio;

  ResultScan(this.nombre, this.descripcion, this.imagen,
      this.audio); //recibe datos desde QrScanner
  @override
  _ResultScanState createState() => _ResultScanState(
      nombre, descripcion, imagen, audio); //envía datos a _ResultScanState
}

class _ResultScanState extends State<ResultScan> {
  String nombre = '';
  String descripcion = '';
  Uint8List imagen = null;
  String audio;

  _ResultScanState(this.nombre, this.descripcion, this.imagen,
      this.audio); //recibe datos desde ResultScan

  static AudioCache cache = AudioCache();
  AudioPlayer player;

  bool isPlaying = false;
  bool isPaused = false;
  bool playerButton = true;

  //hacer que pare cuando se retrocede de vista
  Future<bool> _playerStop() {
    Navigator.of(context).pop(true);
    player.stop();
    isPlaying = false;
  }

  //manejador de play, pause y resume
  void playHandler() async {
    if (isPlaying) {
      if (isPaused) {
        player.resume();
      } else {
        player.pause();
      }
    } else {
      player = await cache.play(audio);
      isPaused = true;
    }

    setState(() {
      isPlaying = true;
      isPaused = !isPaused;
      playerButton = !playerButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    //GRADIENTE CON IMAGEN Y BOTÓN DE AUDIO
    final appbarGradient = Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
            height: 280.0,
            decoration: BoxDecoration(
                color: Color(0xff2F5233),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ))),
        Stack(
          alignment: Alignment(0.7, 1.05),
          children: [
            //IMAGEN
            Container(
              height: 260.0,
              width: 350.0,
              margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: MemoryImage(imagen),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  shape: BoxShape.rectangle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 7.0))
                  ]),
            ),

            //BOTÓN DE AUDIO
            FloatingActionButton(
              backgroundColor: Color(0xff2F5233),
              onPressed: playHandler,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              child: Icon(this.playerButton ? Icons.play_arrow : Icons.pause),
            ),
          ],
        )
      ],
    );

    //DESCRIPCIÓN
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //NOMBRE DE LA FIGURA
        Text(nombre, style: TextStyle(fontFamily: "Lato", fontSize: 24.0)),

        //DESCRIPCIÓN DE LA FIGURA
        Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text(descripcion,
                style: TextStyle(
                    fontFamily: "Lato", fontSize: 16.0, color: Colors.black45)))
      ],
    );

    return Scaffold(
      body: WillPopScope(
        //para manejar el retroceso
        onWillPop: _playerStop, //lleva atrás y para el audio
        child: Stack(
          children: [
            //DESCRIPCIÓN
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 356.0, left: 25.0, right: 25.0),
                  child: description,
                ),
              ],
            ),

            //GRADIENT
            appbarGradient,
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: _playerStop,
              ),
            )
          ],
        ),
      ),
    );
  }
}
