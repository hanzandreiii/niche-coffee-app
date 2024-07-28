import 'package:the_end/parts/individual_bar.dart';

class BarData {
  final double amount0;
  final double amount1;
  final double amount2;
  final double amount3;
  final double amount4;
  final double amount5;
  final double amount6;
  final double amount7;
  final double amount8;
  final double amount9;
  final double amount10;
  final double amount11;
  final double amount12;
  final double amount13;
  final double amount14;
  final double amount15;
  final double amount16;
  final double amount17;
  final double amount18;
  final double amount19;
  final double amount20;
  final double amount21;
  final double amount22;
  final double amount23;

  BarData({
    required this.amount0,
    required this.amount1,
    required this.amount2,
    required this.amount3,
    required this.amount4,
    required this.amount5,
    required this.amount6,
    required this.amount7,
    required this.amount8,
    required this.amount9,
    required this.amount10,
    required this.amount11,
    required this.amount12,
    required this.amount13,
    required this.amount14,
    required this.amount15,
    required this.amount16,
    required this.amount17,
    required this.amount18,
    required this.amount19,
    required this.amount20,
    required this.amount21,
    required this.amount22,
    required this.amount23,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x:0, y:amount0),
      IndividualBar(x:0, y:amount1),
      IndividualBar(x:0, y:amount2),
      IndividualBar(x:0, y:amount3),
      IndividualBar(x:0, y:amount4),
      IndividualBar(x:0, y:amount5),
      IndividualBar(x:0, y:amount6),
      IndividualBar(x:0, y:amount7),
      IndividualBar(x:0, y:amount8),
      IndividualBar(x:0, y:amount9),
      IndividualBar(x:0, y:amount10),
      IndividualBar(x:0, y:amount11),
      IndividualBar(x:0, y:amount12),
      IndividualBar(x:0, y:amount13),
      IndividualBar(x:0, y:amount14),
      IndividualBar(x:0, y:amount15),
      IndividualBar(x:0, y:amount16),
      IndividualBar(x:0, y:amount17),
      IndividualBar(x:0, y:amount18),
      IndividualBar(x:0, y:amount19),
      IndividualBar(x:0, y:amount20),
      IndividualBar(x:0, y:amount21),
      IndividualBar(x:0, y:amount22),
      IndividualBar(x:0, y:amount23),
    ];
  }
}
