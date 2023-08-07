import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculatrice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Calculatrice(),
    );
  }
}

class Calculatrice extends StatefulWidget {
  const Calculatrice({Key? key}) : super(key: key);
  @override
  State<Calculatrice> createState() => _CalculatriceState();
}

class _CalculatriceState extends State<Calculatrice> {
  Color cYellow = const Color.fromARGB(255, 150, 135, 6);
  Color cBlack = const Color.fromARGB(255, 43, 40, 40);
  Color cWhite = const Color.fromARGB(255, 163, 153, 153);
  String equation = "", resultat = "", memoire = "";
  final cm = ContextModel();
  final parser = Parser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBlack,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
                maxWidth: 400, minHeight: 630, maxHeight: 900),
            color: cBlack,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Text(equation,
                          textScaleFactor: 1.5,
                          maxLines: 1,
                          style: TextStyle(color: cWhite)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Text(resultat,
                          textScaleFactor: 2.5,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              touche("+", cYellow),
                              touche("7", cWhite),
                              touche("4", cWhite),
                              touche("1", cWhite),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  height: 50,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                    onPressed: effacer,
                                    onLongPress: () => setState(
                                        () => resultat = equation = ""),
                                    child: Icon(Icons.backspace_outlined,
                                        size: 32, color: cBlack),
                                  )),
                              touche("(", Colors.white),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: cWhite, width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 50,
                                  child: Center(
                                    child: TextButton(
                                        child: Icon(Icons.horizontal_rule,
                                            size: 35, color: cYellow),
                                        onPressed: () => addChar("-")),
                                  )),
                              touche("8", cWhite),
                              touche("5", cWhite),
                              touche("2", cWhite),
                              touche("0", cWhite),
                              touche(")", Colors.white),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              touche("x", cYellow),
                              touche("9", cWhite),
                              touche("6", cWhite),
                              touche("3", cWhite),
                              touche(".", cWhite),
                              touche("^", Colors.white),
                            ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            touche("/", cYellow),
                            toucheDeg("sin", Colors.indigo),
                            toucheDeg("cos", Colors.indigo),
                            toucheDeg("tan", Colors.indigo),
                            Container(
                                margin: const EdgeInsets.all(5),
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                    color: cYellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onLongPress: () {
                                    if (memoire.isEmpty) return;
                                    setState(() => equation += "Ans");
                                    egale(false);
                                  },
                                  onPressed: () => egale(true),
                                  child: Icon(CupertinoIcons.equal,
                                      size: 35, color: cBlack),
                                )),
                            toucheDeg("√", Colors.white),
                          ],
                        ),
                      ])
                ]),
          ),
        ),
      ),
    );
  }

  void effacer() {
    setState(() {
      if (equation.isNotEmpty) {
        if (equation.substring(equation.length - 1) == 'n' ||
            equation.substring(equation.length - 1) == 's') {
          equation = equation.substring(0, (equation.length) - 3);
        } else {
          equation = equation.substring(0, (equation.length) - 1);
        }
        egale(false);
      }
    });
  }

  Widget touche(String ch, Color color) {
    return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: cWhite, width: 1),
            borderRadius: BorderRadius.circular(10)),
        height: 50,
        child: Center(
          child: TextButton(
              child: Text(ch,
                  style: TextStyle(color: color),
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0),
              onPressed: () => addChar(ch)),
        ));
  }

  Widget toucheDeg(String ch, Color color) {
    return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: cWhite, width: 1),
            borderRadius: BorderRadius.circular(10)),
        height: 50,
        child: TextButton(
            child: Text(ch,
                style: TextStyle(color: color),
                textAlign: TextAlign.center,
                textScaleFactor: 2.0),
            onPressed: () => addChar("$ch(")));
  }

  void addChar(String ch) {
    setState(() => equation += ch);
    egale(false);
  }

  void egale(bool bol) {
    if (equation.isEmpty) {
      setState(() => resultat = "");
    } else
    //This case to fix a bug
    if (kIsWeb && isNumeric(equation)) {
      setState(() => resultat = memoire = equation);
    } else {
      setState(() {
        try {
          String equa = equation;
          //check if each Ans is surrounded by operators

          if (equa.contains("Ans") && equa.length > 3) {
            print("Enter here");
            for (int i = 0; i < equa.length - 2; i++) {
              if (equa[i] == "A") {
                if (i - 1 >= 0) {
                  !isOperator(equa[i - 1])
                      ? equa = "${equa.substring(0, i)}x${equa.substring(i)}"
                      : null;
                }
                if (i + 3 < equa.length) {
                  !isOperator(equa[i + 3])
                      ? throw Exception("Erreur de syntaxe")
                      : null;
                }
              }
            }
          }

          equa = equa
              .replaceAll("x", "*")
              .replaceAll("√", "sqrt")
              .replaceAll("Ans", memoire);

          // Fix implicit multiplication bug
          for (int i = 0; i < equa.length - 1; i++) {
            if (isNumeric(equa[i]) &&
                (equa[i + 1] == "s" ||
                    equa[i + 1] == "c" ||
                    equa[i + 1] == "t" ||
                    equa[i + 1] == "(")) {
              equa =
                  "${equa.substring(0, i + 1)}*${equa.substring(i + 1, equa.length)}";
            }
            if (equa[i] == ")" &&
                (equa[i + 1] == "(" ||
                    equa[i + 1] == "s" ||
                    equa[i + 1] == "c" ||
                    equa[i + 1] == "t")) {
              equa =
                  "${equa.substring(0, i + 1)}*${equa.substring(i + 1, equa.length)}";
            }
          }
          print("Avant le parser $equa");
          Expression exp = parser.parse(equa);
          resultat = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (bol) memoire = resultat;
          if (resultat.substring(resultat.length - 2) == ".0") {
            resultat = resultat.substring(0, (resultat.length) - 2);
          }
          if (resultat.length > 15) {
            resultat = resultat.substring(0, 10) +
                resultat.substring(resultat.length - 5);
          }
          if (bol) equation = "Ans";
        } catch (erreur) {
          resultat = bol ? "Erreur de syntaxe" : "";
        }
      });
    }
  }
}

bool isNumeric(String item) {
  return item == '1' ||
      item == '2' ||
      item == '3' ||
      item == '4' ||
      item == '5' ||
      item == '6' ||
      item == '7' ||
      item == '8' ||
      item == '9' ||
      item == '0';
}

bool isOperator(String item) {
  return item == '+' ||
      item == '-' ||
      item == 'x' ||
      item == '/' ||
      item == '^' ||
      item == 's' ||
      item == 'c' ||
      item == 't' ||
      item == '(' ||
      item == ')';
}
