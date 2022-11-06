import 'dart:async';
import 'dart:math';

import 'package:binary_clock/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class BinaryTime {
  List<String>? binaryInt;
  List<String>? binaryInt2;
  BinaryTime() {
    DateTime now = DateTime.now();
    String hhmmss = DateFormat("Hms").format(now).replaceAll(':', '');
    binaryInt = DateFormat("Hms")
        .format(now)
        .split(':')
        .map((e) => int.parse(e).toRadixString(2).padLeft(6, '0'))
        .toList();
    binaryInt2 = hhmmss
        .split('')
        .map((e) => int.parse(e).toRadixString(2).padLeft(4, '0'))
        .toList();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BinaryTime _nowBinary = BinaryTime();
  DateTime now = DateTime.now();
  List<int> rows = [5, 6, 6];
  List<String> title = ['H', 'M', 'S'];

  List<int> rows2 = [2, 4, 3, 4, 3, 4];
  List<String> title2 = ['H', 'h', 'M', 'm', 'S', 's'];
  bool column2 = false;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (callback) {
      setState(() {
        _nowBinary = BinaryTime();
        now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> binaryInteger;
    int binaryCell;
    List<String> title_;
    List<int> rows_;
    int maxrow, padLeft;

    if (column2) {
      binaryInteger = _nowBinary.binaryInt2!;
      title_ = title2;
      rows_ = rows2;
      binaryCell = 3;
      maxrow = 4;
      padLeft = 1;
    } else {
      binaryInteger = _nowBinary.binaryInt!;
      rows_ = rows;
      title_ = title;
      binaryCell = 5;
      maxrow = 6;
      padLeft = 2;
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('Hms').format(now),
            style: const TextStyle(fontSize: 32, color: blue),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '1 Column',
                style: TextStyle(color: green, fontSize: 16),
              ),
              Switch.adaptive(
                  inactiveTrackColor: green,
                  activeTrackColor: blue,
                  value: column2,
                  onChanged: (value) {
                    setState(() {
                      column2 = value;
                    });
                  }),
              const Text(
                '2 Column',
                style: TextStyle(color: blue, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(binaryInteger.length, (index) {
                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: BinaryColumn(
                        maxrow: maxrow,
                        binaryCell: binaryCell,
                        binaryInteger: binaryInteger[index],
                        title: title_[index],
                        padLeft: padLeft,
                        row: rows_[index]));
              }))
        ],
      ),
    );
  }
}

class BinaryColumn extends StatelessWidget {
  const BinaryColumn({
    Key? key,
    required this.title,
    required this.row,
    required this.binaryInteger,
    required this.binaryCell,
    required this.maxrow,
    required this.padLeft,
  }) : super(key: key);
  final String binaryInteger;
  final int binaryCell;
  final String title;
  final int row, maxrow, padLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              color: green, fontSize: 24, fontWeight: FontWeight.w400),
        ),
        ...List.generate(binaryInteger.split('').length, (index) {
          int binaryCellValue = pow(2, binaryCell - index).toInt();
          bool isActive = binaryInteger.split('')[index] == '1';
          Color color = isActive
              ? blue
              : index < maxrow - row
                  ? white
                  : black.withOpacity(.38);
          String text = isActive ? binaryCellValue.toString() : '';
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(top: 5, bottom: 5)
                : const EdgeInsets.only(bottom: 5),
            child: CustomContainer(
              color: color,
              text: text,
            ),
          );
        }),
        Text(
          int.parse(binaryInteger, radix: 2).toString().padLeft(padLeft, '0'),
          style: const TextStyle(
              color: green, fontSize: 24, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, color: white, fontWeight: FontWeight.bold),
      )),
    );
  }
}
