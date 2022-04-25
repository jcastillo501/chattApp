import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/providers/chats_provider.dart';
import 'package:digi_chatt/providers/home_provider.dart';
import 'package:digi_chatt/providers/login_provider.dart';
import 'package:digi_chatt/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late LoginProvider loginProvider;
  late ChatsProvider chatsProvider;
  late HomeProvider homeProvider;
  late double screendHeight;
  late double screendWidth;
  bool firstEnter = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
      loginProvider = Provider.of<LoginProvider>(context);
      chatsProvider = Provider.of<ChatsProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Chat Room')],
          ),
          actions: [
            Container(
              child: IconButton(
                  onPressed: () {
                    loginProvider.signOutGoogle();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const WelcomeScreen()));
                  },
                  icon: const Icon(Icons.login_rounded)),
            )
          ],
          backgroundColor: Colors.purple,
          // title: const Center(child: Text('Chats')),
        ),
        body: _listChats(context));
  }

  SingleChildScrollView _listChats(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      SizedBox(
          height: screendHeight * 0.4,
          width: screendWidth,
          child: ListView.builder(
              itemCount: chatsProvider.chatList.length,
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
                                child:
                                    Text(chatsProvider.chatList[index].idFrom),
                              ),
                              Text(chatsProvider.chatList[index].idTo),
                              Text(chatsProvider.chatList[index].message),
                            ],
                          )),
                      onTap: () async {
                        // await db
                        //     .collection('chats')
                        //     .doc('user_contact')
                        //     .update({
                        //   'userId': loginProvider.firebaseUser?.uid,
                        //   'contactId': homeProvider.userList[index].userId
                        // });
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) => const ChatRoomScreen()));
                      },
                    )
                  ],
                );
              }))
    ]));
  }
}
