import 'package:digi_chatt/screens/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late double screendHeight;
  late double screendWidth;
  bool firstEnter = false;
  @override
  void didChangeDependencies() {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Colors.orange,
          body: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: _bodyPage(),
      )),
    );
  }

  Container _bodyPage() {
    return Container(
      height: screendHeight,
      width: screendWidth,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.center,
            end: Alignment(0.0, 1.0),
            colors: <Color>[
              Color.fromARGB(255, 243, 133, 30),
              Color.fromARGB(255, 247, 46, 203),
            ],
          ),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: screendHeight * 0.08,
          ),
          const Text(
            'Welcome',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Colors.purpleAccent),
          ),
          const Text(
            'Digi Chat',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white70),
          ),
          SizedBox(
            height: screendHeight * 0.08,
          ),
          const Text(
            'Conectate y chatea con nosotros',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white70),
          ),
          Container(
            width: screendWidth * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: MaterialButton(
                child: const Text('Continuar',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent)),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                }),
          )
        ],
      ),
    );
  }
}
