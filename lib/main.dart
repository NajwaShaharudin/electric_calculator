import 'package:electric_calculator/electricalCalculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title:'Electrical Usage Calculator',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: electricalCalculator(),
  ));
}

