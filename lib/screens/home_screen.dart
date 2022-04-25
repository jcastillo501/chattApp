// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/providers/chats_provider.dart';
import 'package:digi_chatt/providers/home_provider.dart';
import 'package:digi_chatt/providers/login_provider.dart';
import 'package:digi_chatt/screens/chat_room_screen.dart';
import 'package:digi_chatt/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<HomeScreen> {
  late LoginProvider loginProvider;
  late HomeProvider homeProvider;
  late ChatsProvider chatsProvider;
  late double screendHeight;
  late double screendWidth;
  bool firstEnter = false;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() async {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
      loginProvider = Provider.of<LoginProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      chatsProvider = Provider.of<ChatsProvider>(context);

      await homeProvider.getContats(context);
      // await loginProvider.conectionStatus(loginProvider.status);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Home Screen')],
          ),
          actions: [
            Container(
              child: IconButton(
                  onPressed: () {
                    loginProvider.signOutGoogle();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const WelcomeScreen()));
                  },
                  icon: const Icon(Icons.logout_rounded)),
            )
          ],
          backgroundColor: Colors.purple,
        ),
        body: _listContacts(context));
  }

  SingleChildScrollView _listContacts(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: screendHeight * 0.4,
            width: screendWidth,
            child: ListView.builder(
                itemCount: homeProvider.userList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: screendHeight * 0.01),
                      GestureDetector(
                        child: Container(
                            height: screendHeight * 0.08,
                            width: screendWidth,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screendWidth * 0.06,
                                      top: screendHeight * 0.01),
                                  child: Text(
                                      homeProvider.userList[index].userName),
                                ),
                                Text(homeProvider.userList[index].userId),
                                Text(homeProvider.userList[index].status),
                                // Text(homeProvider.userList[index].status),
                              ],
                            )),
                        onTap: () async {
                          chatsProvider.generateChatId(
                              loginProvider.firebaseUser?.uid,
                              homeProvider.userList[index].userId);
                          await db
                              .collection('chats')
                              .doc(chatsProvider.chatId)
                              .set({
                            'idFrom': loginProvider.firebaseUser?.uid,
                            'idTo': homeProvider.userList[index].userId,
                            'timeSend': DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            'message': 'holaaa',
                            'chattingWith':
                                homeProvider.userList[index].userName
                          });
                          chatsProvider.getChats(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ChatRoomScreen()));
                        },
                      )
                    ],
                  );
                }),
          ),
          // MaterialButton(
          //   onPressed: () {
          //     homeProvider.getContats(context);
          //   },
          //   child: const Text('refresssh'),
          // ),
        ],
      ),
    );
  }
}
