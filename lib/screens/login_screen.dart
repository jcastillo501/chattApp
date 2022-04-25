import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/providers/login_provider.dart';
import 'package:digi_chatt/screens/add_data.dart';

import 'package:digi_chatt/screens/home_screen.dart';
import 'package:digi_chatt/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginProvider loginProvider;
  late double screendHeight;
  late double screendWidth;
  bool firstEnter = false;

  @override
  void didChangeDependencies() {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
      loginProvider = Provider.of<LoginProvider>(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(child: _bubbleTop()),
                  Positioned(
                      left: -100,
                      top: -80,
                      child:
                          _bubbleTop2(screendHeight * 0.5, screendWidth * 1.2)),
                  Positioned(
                      left: -140,
                      top: -20,
                      child:
                          _bubbleTop2(screendHeight * 0.2, screendWidth * 1)),
                  const Positioned(
                      left: 130,
                      top: 130,
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      )),
                  const Positioned(
                      left: 130,
                      top: 170,
                      child: Text(
                        'TO CONTINUE',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      )),
                ],
              ),
              Container(
                child: Stack(
                  children: [
                    _loginForm(),
                    SizedBox(
                      height: screendHeight * 0.03,
                    ),
                    Positioned(right: 80, bottom: 5, child: _forgotPass()),
                  ],
                ),
              ),
              SizedBox(height: screendHeight * 0.03),
              _loginButton(),
              SizedBox(height: screendHeight * 0.02),
              const Text('or'),
              _googleButtom(),
              _createAccount()
            ],
          ),
        ),
      ),
    );
  }

  _bubbleTop() {
    return SizedBox(
      height: screendHeight * 0.48,
      width: screendWidth,
    );
  }

  _bubbleTop2(double heightB, double widthB) {
    return Container(
      height: heightB,
      width: widthB,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment(0.0, 1.0),
          colors: <Color>[
            Color.fromARGB(255, 243, 133, 30),
            Color.fromARGB(255, 247, 46, 203),
          ],
        ),
      ),
    );
  }

  _loginForm() {
    return Form(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screendWidth * 0.2),
          child: TextFormField(
            onChanged: (value) => loginProvider.email = value,
            decoration: const InputDecoration(
                hintText: 'Email', hintStyle: TextStyle(color: Colors.purple)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screendWidth * 0.2, vertical: screendHeight * 0.03),
          child: TextFormField(
            onChanged: (value) => loginProvider.password = value,
            decoration: const InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.purple)),
          ),
        )
      ],
    ));
  }

  _loginButton() {
    return Container(
      width: screendWidth * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.center,
          // end: Alignment(0.0, 1.0),
          colors: <Color>[
            Color.fromARGB(255, 243, 133, 30),
            Color.fromARGB(255, 247, 46, 203),
          ],
        ),
      ),
      child: MaterialButton(
          child: const Text('LOG IN',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 241, 239, 241))),
          onPressed: () async {
            dynamic result =
                await loginProvider.checkIfEmailInUse(loginProvider.email);
            if (result == true) {
              loginProvider.signIn(loginProvider.email, loginProvider.password);
              print('loggueado con exito');

              DocumentSnapshot docUser = await loginProvider.db
                  .collection('users')
                  .doc(loginProvider.firebaseUser?.uid)
                  .get();
              if (docUser.exists) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddDataScreen()));
              }
            } else if (result == false) {
              print('correo no registrado');
            }
          }),
    );
  }

  _googleButtom() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screendHeight * 0.02, horizontal: screendWidth * 0.25),
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/icons/googleIcon.jpg',
              height: screendHeight * 0.03,
            ),
            Container(
                padding: EdgeInsets.only(
                    left: screendWidth * 0.01, right: screendWidth * 0.01),
                child: const Text(
                  "Sign in with Google",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        onPressed: () async {
          await loginProvider.signinGoogle();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HomeScreen()));

          // dynamic result = await loginProvider
          //     .checkIfEmailInUse(loginProvider.firebaseUser!.email);
          // if (result == true) {
          //   print('este correo pertenese a otra cuenta');
          // } else if (result == false) {
          //   print('exito al entrar');
          //
          // }
        },
      ),
    );
  }

  _forgotPass() {
    return GestureDetector(
      child: const Text(
        'Forgot it?',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.purple),
      ),
      onTap: () {},
    );
  }

  _createAccount() {
    return GestureDetector(
      child: const Text(
        ' Create a new account',
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.purple,
            decoration: TextDecoration.underline),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
      },
    );
  }
}
