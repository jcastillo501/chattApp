import 'package:digi_chatt/providers/login_provider.dart';
import 'package:digi_chatt/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late double screendHeight;
  late double screendWidth;
  late LoginProvider loginProvider;
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
                        'SIGN UP',
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
              Stack(
                children: [
                  _signUpForm(),
                  SizedBox(
                    height: screendHeight * 0.03,
                  ),
                ],
              ),
              SizedBox(
                height: screendHeight * 0.03,
              ),
              _signUpButton(context),
              SizedBox(height: screendHeight * 0.03),
              _goLogin()
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

  _signUpForm() {
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

  _signUpButton(BuildContext context) {
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
          child: const Text('SIGN UP',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 241, 239, 241))),
          onPressed: () async {
            dynamic result =
                await loginProvider.checkIfEmailInUse(loginProvider.email);
            if (result == true) {
              print('el correo ya tiene una cuenta');
            } else if (result == false) {
              loginProvider.signUp(loginProvider.email, loginProvider.password);
              print('Registrado con exito');
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          }),
    );
  }

  _goLogin() {
    return Column(
      children: [
        const Text(
          ' Do you already have an account?',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.purple,
          ),
        ),
        GestureDetector(
          child: const Text(
            ' Login Now?',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.purple,
                decoration: TextDecoration.underline),
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
      ],
    );
  }
}
