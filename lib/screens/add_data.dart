import 'package:digi_chatt/providers/add_data_provider.dart';
import 'package:digi_chatt/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key}) : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  late UserFormProvider userProvider;
  late double screendHeight;
  late double screendWidth;
  bool firstEnter = false;
  @override
  void didChangeDependencies() {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
      userProvider = Provider.of<UserFormProvider>(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        width: screendWidth,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(25)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: screendHeight * 0.06,
            ),
            const Text('ADD DATA',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)),
            const Text('TO CONTINUE',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 241, 239, 241))),
            SizedBox(
              height: screendHeight * 0.1,
            ),
            _dataForm(),
            SizedBox(
              height: screendHeight * 0.03,
            ),
            _addButton()
          ],
        ),
      )),
    );
  }

  _dataForm() {
    return Form(
        // key: userProvider.formkey,
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screendWidth * 0.2, vertical: screendHeight * 0.02),
          child: TextFormField(
            onChanged: (value) => userProvider.nameCont = value,
            decoration: const InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screendWidth * 0.2, vertical: screendHeight * 0.02),
          child: TextFormField(
            onChanged: (value) => userProvider.telf = '+57' + value,
            decoration: const InputDecoration(
                hintText: 'Phone', hintStyle: TextStyle(color: Colors.white)),
          ),
        )
      ],
    ));
  }

  _addButton() {
    return Container(
      width: screendWidth * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.white),
      child: MaterialButton(
          child: const Text('CONTINUAR',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
          onPressed: () async {
            await userProvider.addData(
                userProvider.nameCont, userProvider.telf);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
          }),
    );
  }
}
