import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotechjsc_app/config/themes/app_color.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';
import 'package:gotechjsc_app/helperfunction/sharedpref_helper.dart';
import 'package:gotechjsc_app/modules/authen/sign-in/sign_in.dart';
import 'package:gotechjsc_app/modules/chat/screens/chat.dart';
import 'package:gotechjsc_app/modules/home/widgets/chat_room.dart';
import 'package:gotechjsc_app/modules/home/widgets/search_bar.dart';
import 'package:gotechjsc_app/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myName, myProfilePic, myUserName, myEmail;

  static final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> userInfo = {
    "email": "nullemail@gmail.com",
    "username": "nullemail",
    "name": "nullname",
    "imgUrl": AssetPath.logo,
    "userId": FirebaseAuth.instance.currentUser!.uid
  };

  initialUser() async {
    userInfo = await DatabaseMethods()
        .getUserInfo(FirebaseAuth.instance.currentUser!.uid);
  }

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  getMyInfoFromSharedPreference() async {
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialUser();
    getMyInfoFromSharedPreference();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //white status bar
    final FirebaseAuth auth = FirebaseAuth.instance;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DarkTheme.darkGreyBackground,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: DarkTheme.darkGreyBackground));

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            elevation: 0,
            backgroundColor: DarkTheme.darkGreyBackground,
            flexibleSpace: SafeArea(
                child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: size.height / 8,
                    child: FutureBuilder<dynamic>(
                        future: DatabaseMethods().getUserInfo(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Load Error'),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: size.height / 24,
                                backgroundImage:
                                    AssetImage(snapshot.data['imgUrl']),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  snapshot.data['name'],
                                  style: TxtStyle.heading1,
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Image.asset(AssetPath.iconArrowRight),
                  )
                ],
              ),
            )),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            decoration:
                const BoxDecoration(color: DarkTheme.darkGreyBackground),
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchBar(size: size),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 24),
                    child: const Text(
                      'Messages',
                      style: TxtStyle.heading2,
                    ),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: users,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Load Error');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return data['userId'] !=
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? GestureDetector(
                                        onTap: () {
                                          var chatRoomId =
                                              getChatRoomIdByUsernames(
                                                  data['userId'],
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid);
                                          Map<String, dynamic> chatRoomInfoMap =
                                              {
                                            "users": [
                                              data['userId'],
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ]
                                          };
                                          DatabaseMethods().createChatRoom(
                                              chatRoomId, chatRoomInfoMap);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Chat(
                                                      uidFriend: data['userId'],
                                                      uidMe: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      imgUrl: data['imgUrl'],
                                                      name: data['name'])));
                                        },
                                        child: Container(
                                          height: size.height / 9,
                                          width: size.height / 11,
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(children: [
                                            CircleAvatar(
                                              radius: size.height / 27,
                                              backgroundImage:
                                                  AssetImage(data['imgUrl']),
                                            ),
                                            Text(data['name'],
                                                style: TxtStyle.heading5r,
                                                overflow: TextOverflow.ellipsis)
                                          ]),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 1,
                                      );
                              }).toList(),
                            );
                          })),
                  Container(
                    margin: const EdgeInsets.only(top: 24, left: 24, right: 10),
                    width: size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: users,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Load Error');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return data['userId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? GestureDetector(
                                      onTap: () {
                                        var chatRoomId =
                                            getChatRoomIdByUsernames(
                                                data['userId'],
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);
                                        Map<String, dynamic> chatRoomInfoMap = {
                                          "users": [
                                            data['userId'],
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ]
                                        };
                                        DatabaseMethods().createChatRoom(
                                            chatRoomId, chatRoomInfoMap);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Chat(
                                                    uidFriend: data['userId'],
                                                    uidMe: FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    imgUrl: data['imgUrl'],
                                                    name: data['name'])));
                                      },
                                      child: SizedBox(
                                          height: size.height / 11,
                                          child: Row(children: [
                                            Row(children: [
                                              CircleAvatar(
                                                radius: size.height / 27,
                                                backgroundImage:
                                                    AssetImage(data['imgUrl']),
                                              ),
                                              Container(
                                                width: size.width / 1.5,
                                                height: size.height / 14,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(data['name'],
                                                              style: TxtStyle
                                                                  .heading4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                          Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: DarkTheme
                                                                    .lightBlue),
                                                          )
                                                        ],
                                                      ),
                                                      const Text(
                                                          "Let's start chatting...",
                                                          style: TxtStyle
                                                              .heading5l,
                                                          overflow: TextOverflow
                                                              .ellipsis)
                                                    ]),
                                              )
                                            ])
                                          ])),
                                    )
                                  : SizedBox(
                                      width: 1,
                                    );
                            }).toList(),
                          );
                        }),
                  )
                ],
              ),
            ]),
          ),
        ));
  }
}
