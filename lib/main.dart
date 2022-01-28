import 'package:flutter/material.dart';
import 'package:mysql_practice/pages/Homepage.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mysql Practice',
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
