import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

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
  String aff = "", equation = "", memoire = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Calculatrice'),
        centerTitle: true, //62 24 61 86
        backgroundColor: cBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: cBlack,
          height: MediaQuery.of(context).size.height - 60,
          width: MediaQuery.of(context).size.width,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 1 / 10),
              child: Text(equation, textScaleFactor: 1.5, maxLines: 4, style: TextStyle(color: cWhite)),
            ),
            Container(margin: EdgeInsets.only(right: (MediaQuery.of(context).size.width * 1 / 10) + 10), child: Text(aff, textScaleFactor: 4.0, style: const TextStyle(color: Colors.white))),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                colonne(touche("(", Colors.white), touche("7", cWhite), touche("4", cWhite), touche("1", cWhite), touche("0", cWhite)),
                colonne(touche(")", Colors.white), touche("8", cWhite), touche("5", cWhite), touche("2", cWhite), touche(".", cWhite)),
                colonne(
                    touche("^", Colors.white),
                    touche("9", cWhite),
                    touche("6", cWhite),
                    touche("3", cWhite),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextButton(
                        onPressed: effacer,
                        onLongPress: toutEffacer,
                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(cWhite), backgroundColor: MaterialStateProperty.all<Color>(cBlack)),
                        child: const Icon(Icons.cancel_outlined, size: 35.0),
                      ),
                    )),
                colonne(toucheDeg("√", Colors.white), toucheDeg("sin", Colors.indigo), toucheDeg("cos", Colors.indigo), toucheDeg("tan", Colors.indigo), touche("mod", Colors.indigo)),
                colonne(
                    touche("/", cYellow),
                    touche("x", cYellow),
                    touche("+", cYellow),
                    touche("-", cYellow),
                    ElevatedButton(
                      onLongPress: () {
                        setState(() {
                          aff = equation = memoire;
                        });
                      },
                      onPressed: () => egale(true),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(cYellow)),
                      child: const Icon(CupertinoIcons.equal, size: 55.0),
                    )),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget colonne(Widget a, Widget b, Widget c, Widget d, Widget e) {
    return SizedBox(height: 300, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [a, b, c, d, e]));
  }

  void effacer() {
    setState(() {
      if (equation.isNotEmpty) {
        if (equation.substring(equation.length - 1) == 'n' || equation.substring(equation.length - 1) == 's' || equation.substring(equation.length - 1) == 'd') {
          equation = equation.substring(0, (equation.length) - 3);
        } else {
          equation = equation.substring(0, (equation.length) - 1);
        }
        egale(false);
      }
    });
  }

  void toutEffacer() {
    setState(() {
      aff = "";
      equation = "";
    });
  }

  Widget touche(String ch, Color color) {
    return SizedBox(height: 50, child: TextButton(child: Text(ch, style: TextStyle(color: color), textAlign: TextAlign.center, textScaleFactor: 2.0), onPressed: () => addChar(ch)));
  }

  Widget toucheDeg(String ch, Color color) {
    return SizedBox(height: 50, child: TextButton(child: Text(ch, style: TextStyle(color: color), textAlign: TextAlign.center, textScaleFactor: 2.0), onPressed: () => addChar("$ch(")));
  }

  void addChar(String ch) {
    setState(() {
      equation += ch;
      egale(false);
    });
  }

  void egale(bool bol) {
    if (equation.isEmpty) {
      aff = "";
    } else
    //This case to fix a bug
    if (kIsWeb &&
        (equation == '1' || equation == '2' || equation == '3' || equation == '4' || equation == '5' || equation == '6' || equation == '7' || equation == '8' || equation == '9' || equation == '0')) {
      aff = equation;
      memoire = equation;
    } else {
      setState(() {
        try {
          String equa = equation;
          equa = equa.replaceAll("x", "*").replaceAll("√", "sqrt").replaceAll("mod", "%");

          Parser p = Parser();
          Expression exp = p.parse(equa);
          ContextModel cm = ContextModel();
          aff = '${exp.evaluate(EvaluationType.REAL, cm)}';

          memoire = aff;
          if (aff.substring(aff.length - 2) == ".0") aff = aff.substring(0, (aff.length) - 2);
          if (aff.length > 15) aff = aff.substring(0, 10) + aff.substring(aff.length - 5);
        } catch (erreur) {
          if (bol) aff = "Erreur de syntaxe ";
        }
      });
    }
  }
}
