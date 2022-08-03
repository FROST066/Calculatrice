import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:function_tree/function_tree.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Calculatrice'), centerTitle: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 25.0),
            Text(equation, textScaleFactor: 2.0),
            Text(aff, textScaleFactor: 3.0),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    height: 350.0,
                    width: 510.0,
                    decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      ligne(touche("("), touche("."), touche(")"), ope("+"), ope("mod"), Container(width: 0)),
                      ligne(touche("7"), touche("8"), touche("9"), ope("-"), ope("sin"), Container(width: 2)),
                      ligne(touche("4"), touche("5"), touche("6"), ope("x"), ope("cos"), Container(width: 2)),
                      ligne(touche("1"), touche("2"), touche("3"), ope("/"), ope("tan"), Container(width: 2)),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        ElevatedButton(
                          onPressed: effacer,
                          onLongPress: tout_effacer,
                          child: const Icon(CupertinoIcons.xmark_circle, size: 40.0),
                        ),
                        touche("0"),
                        touche("00"),
                        SizedBox(height: 60.0, width: 165.0, child: ElevatedButton(child: const Icon(CupertinoIcons.equal, size: 55.0), onPressed: () => egale(true))),
                        Container(width: 7)
                      ])
                    ])))
          ],
        ));
  }

  void effacer() {
    setState(() {
      if (equation.isNotEmpty) {
        equation = equation.substring(0, (equation.length) - 1);
        egale(false);
      }
    });
  }

  void tout_effacer() {
    setState(() {
      aff = "";
      equation = "";
    });
  }

  TextButton touche(String ch) {
    return TextButton(child: Text(ch, style: TextStyle(color: Colors.indigo[100]), textAlign: TextAlign.center, textScaleFactor: 2.0), onPressed: () => add_char(ch));
  }

  void add_char(String ch) {
    if (equation.length < 22)
      setState(() {
        equation = equation + ch;
        egale(false);
      });
  }

  Widget ope(String ch) {
    return Container(color: Colors.indigo, child: touche(ch));
  }

  Row ligne(Widget a, Widget b, Widget c, Widget d, Widget e, Widget f) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [a, b, c, d, e, f],
    );
  }

  void egale(bool bol) {
    if (equation.isEmpty)
      aff = "";
    else {
      setState(() {
        try {
          String equa = equation;
          equa = equa.replaceAll("mod", "%").replaceAll("x", "*");
          // aff="${equa.interpret()}";
          if (aff.substring(aff.length - 2) == ".0") aff = aff.substring(0, (aff.length) - 2);
          if (aff.length > 15) aff = aff.substring(0, 10) + aff.substring(aff.length - 5);
        } catch (erreur) {
          if (bol) aff = "Erreur de syntaxe";
        }
      });
    }
  }
}
