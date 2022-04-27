import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/user_model.dart';
import 'package:digi_chatt/providers/chats_provider.dart';
import 'package:digi_chatt/providers/home_provider.dart';
import 'package:digi_chatt/providers/login_provider.dart';
import 'package:digi_chatt/screens/home_screen.dart';
import 'package:digi_chatt/screens/welcome_screen.dart';
import 'package:digi_chatt/widgets/message_bubble.dart';
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
  List<UserModel> userList2 = [];
  bool firstEnter = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String msgController;

  @override
  void didChangeDependencies() async {
    if (!firstEnter) {
      firstEnter = true;
      screendHeight = MediaQuery.of(context).size.height;
      screendWidth = MediaQuery.of(context).size.width;
      loginProvider = Provider.of<LoginProvider>(context);
      chatsProvider = Provider.of<ChatsProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      msgController = chatsProvider.msg.text;
      await chatsProvider.getMessages();
      for (var item in homeProvider.userList) {
        userList2.add(item);
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const HomeScreen()));
                      chatsProvider.msgList.clear();
                      homeProvider.userList.clear();
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              Padding(
                padding: EdgeInsets.only(left: screendWidth * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Chats')],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Container(
                  child: IconButton(
                      onPressed: () async {
                        await loginProvider.signOutGoogle();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const WelcomeScreen()));
                      },
                      icon: const Icon(Icons.logout_sharp)),
                ),
              ],
            )
          ],
          backgroundColor: Colors.purple,
          // title: const Center(child: Text('Chats')),
        ),
        body: _listChats(context));
  }

  SingleChildScrollView _listChats(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: screendHeight * 0.8,
              width: screendWidth,
              child: chatsProvider.msgList.isNotEmpty
                  ? ListView.builder(
                      reverse: true,
                      itemCount: chatsProvider.msgList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: MessageBubble(
                              messagetext: chatsProvider.msgList[index].message,
                              username:
                                  chatsProvider.msgList[index].messageUser,
                              isMine: chatsProvider.firebaseUser?.uid ==
                                  chatsProvider.msgList[index].idFrom,
                              key: ValueKey(chatsProvider.msgList[index].id)),
                          onTap: () async {
                            print('Se esta seleccionando el mensaje:  ' +
                                chatsProvider.msgList[index].message);
                            // await chatsProvider.deleteMessage();
                          },
                        );
                      },
                    )
                  : const Center(child: Text('No hay mensajes aun'))),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 34, 34),
                borderRadius: BorderRadius.circular(25)),
            width: screendWidth * 0.9,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: screendHeight * 0.03),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: chatsProvider.msg,
                    onSubmitted: (value) => chatsProvider.msg.text = value,
                    decoration: const InputDecoration(
                        hintText: 'mensaje',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    await chatsProvider.sendMessage(
                        chatsProvider.msg,
                        loginProvider.firebaseUser?.displayName,
                        homeProvider.userList[homeProvider.indexs].userName);
                    chatsProvider.msg.clear();
                    chatsProvider.msgList.clear();
                    await chatsProvider.getMessages();
                  },
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.orange,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
