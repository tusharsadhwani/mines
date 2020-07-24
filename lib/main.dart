import 'package:flutter/material.dart';

import 'widgets/mines.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const primaryColor = Color.fromRGBO(160, 149, 97, 1.0);
  static const backgroundColor = Color.fromRGBO(15, 15, 15, 1.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        accentColor: Colors.white,
        primaryColor: primaryColor,
        dialogTheme: DialogTheme(
          backgroundColor: backgroundColor,
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontSize: 24.0,
          ),
        ),
        canvasColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          headline1: TextStyle(color: primaryColor),
          headline2: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w300,
          ),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mines'),
      ),
      body: Center(
        child: Mines(),
      ),
    );
  }
}
