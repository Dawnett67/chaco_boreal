import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'qr_scanner.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Chaco Boreal',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), //llama al SplashScreen
    );
  }
}

//CLASE CON EL SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _mockCheckForSession().then((value) =>
        _navigateToHome()); //después de 5 segundos llama a _navigateHome
  }

  //crea un delay de 5 segundos
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 8000), () {});
    return true;
  }

  //lleva a la vista QrScanner
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => QrScanner()));
  }

  @override
  Widget build(BuildContext context) {
    //crea la vista del splash screen
    return Scaffold(
      body: Container(
        color: Color(0xff2F5233),
        alignment: Alignment.center,
        child: Shimmer.fromColors(
            child: Image.asset("assets/img/soldado.png"),
            baseColor: Color(0xff2F5233),
            highlightColor: Color(0xff003300)),
      ),
    );
  }
}
