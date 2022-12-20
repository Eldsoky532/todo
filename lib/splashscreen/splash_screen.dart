import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/style/style.dart' as Style;


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds:5),
            ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen())));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Container(
            height: 200,
            width: 150,
            child: Align(
                alignment: Alignment.center,
                child: Image(image: AssetImage('asset/img/mm.png'))
            ),
          ),

          SizedBox(
            height: 1,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'ToDo App',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Style.Colors.maincolor),
            ),
          ),
        ],
      ),
    );
  }
}
