import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotechjsc_app/config/themes/app_color.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';
import 'package:gotechjsc_app/helperfunction/sharedpref_helper.dart';
import 'package:gotechjsc_app/modules/authen/sign-in/sign_in.dart';
import 'package:gotechjsc_app/services/database.dart';
import 'package:random_string/random_string.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.uidFriend,
      required this.uidMe,
      required this.imgUrl,
      required this.name})
      : super(key: key);
  final String uidFriend, uidMe, imgUrl, name;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot>? messageStream;
  String chatRoomId = "";
  String messageId = "";
  String? myName, myProfilePic, myUserName, myEmail;
  getMyInfoFromSharedPreference() async {
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();

    chatRoomId = getChatRoomIdByUsernames(widget.uidFriend, widget.uidMe);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (inputMessageController.text != "" && sendClicked) {
      String messsage = inputMessageController.text;
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": messsage,
        "sendBy": widget.uidMe,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": messsage,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": widget.uidMe
        };
        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        //remove text in textfield
        if (sendClicked) {
          inputMessageController.text = "";
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTitle(String message, bool sendByMe) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: Align(
        alignment: (sendByMe ? Alignment.topRight : Alignment.topLeft),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (sendByMe
                  ? DarkTheme.darkerMessages
                  : DarkTheme.greyMessage)),
          child: Text(
            message,
          ),
        ),
      ),
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    // TODO: implement initState
    super.initState();
  }

  TextEditingController inputMessageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //white status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DarkTheme.darkGreyBackground,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: DarkTheme.darkGreyBackground));
    _scrollToBottom();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: DarkTheme.darkGreyBackground,
          flexibleSpace: SafeArea(child: AppBarChatWidget(size)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return chatMessageTitle(
                                  ds["message"],
                                  FirebaseAuth.instance.currentUser!.uid ==
                                      ds['sendBy']);
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.only(left: 20),
            margin:
                const EdgeInsets.only(left: 24, top: 15, bottom: 15, right: 24),
            decoration: BoxDecoration(
                color: DarkTheme.veryDark,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextField(
                  controller: inputMessageController,
                  onChanged: (value) {
                    addMessage(false);
                  },
                  onSubmitted: (String str) {
                    // addMessage(inputMessageController.text);
                  },
                  decoration: InputDecoration(
                      hintText: 'Write...',
                      hintStyle: TxtStyle.searchText,
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    addMessage(true);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: DarkTheme.greyMessage,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        addMessage(true);
                      },
                      icon: Image.asset(AssetPath.iconMessage),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AppBarChatWidget(size) {
    return Container(
      height: size.height / 9,
      padding: const EdgeInsets.only(left: 50, right: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: size.height / 30,
            backgroundImage: AssetImage(widget.imgUrl),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              widget.name,
              style: TxtStyle.heading3,
            ),
          )
        ],
      ),
    );
  }

  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}
