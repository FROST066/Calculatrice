import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

late String aff = "", equation = "";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Calculatrice(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculatrice'),
        centerTitle: true,
        backgroundColor: cBlack,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          color: cBlack,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(equation, textScaleFactor: 1.5, maxLines: 4, style: TextStyle(color: cWhite)),
              ),
              Text(aff, textScaleFactor: 4.0, style: const TextStyle(color: Colors.white)),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height * 6 / 10,
                    width: MediaQuery.of(context).size.width * 8 / 10,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      colonne(touche("(", cWhite), touche("7", cWhite), touche("4", cWhite), touche("1", cWhite), touche("0", cWhite)),
                      colonne(touche(")", cWhite), touche("8", cWhite), touche("5", cWhite), touche("2", cWhite), touche(".", cWhite)),
                      colonne(
                          touche("%", cWhite),
                          touche("9", cWhite),
                          touche("6", cWhite),
                          touche("3", cWhite),
                          TextButton(
                            onPressed: effacer,
                            onLongPress: toutEffacer,
                            style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(cWhite), backgroundColor: MaterialStateProperty.all<Color>(cBlack)),
                            child: const Icon(Icons.cancel_outlined, size: 55.0),
                          )),
                      colonne(
                          touche("/", cYellow),
                          touche("x", cYellow),
                          touche("+", cYellow),
                          touche("-", cYellow),
                          ElevatedButton(
                            onPressed: () => egale(true),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(cYellow)),
                            child: const Icon(CupertinoIcons.equal, size: 55.0),
                          )),
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget colonne(Widget a, Widget b, Widget c, Widget d, Widget e) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [a, b, c, d, e]);
  }

  void effacer() {
    setState(() {
      if (equation.isNotEmpty) {
        equation = equation.substring(0, (equation.length) - 1);
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
    return Container(width: 50, height: 50, child: TextButton(child: Text(ch, style: TextStyle(color: color), textAlign: TextAlign.center, textScaleFactor: 2.0), onPressed: () => add_char(ch)));
  }

  void add_char(String ch) {
    if (equation.length < 22) {
      setState(() {
        equation += ch;
        egale(false);
      });
    }
  }

  void egale(bool bol) {
    if (equation.isEmpty) {
      aff = "";
    } else {
      setState(() {
        try {
          String equa = equation;
          equa = equa.replaceAll("x", "*");
          Parser p = Parser();
          Expression exp = p.parse(equa);
          ContextModel cm = ContextModel();
          aff = '${exp.evaluate(EvaluationType.REAL, cm)}';

          if (aff.substring(aff.length - 2) == ".0") aff = aff.substring(0, (aff.length) - 2);
          if (aff.length > 15) aff = aff.substring(0, 10) + aff.substring(aff.length - 5);
        } catch (erreur) {
          if (bol) aff = "Erreur de syntaxe ";
        }
      });
    }
  }
}
