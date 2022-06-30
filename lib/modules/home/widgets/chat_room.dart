import 'package:flutter/material.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height / 11,
        child: Row(children: [
          Row(children: [
            CircleAvatar(
              radius: size.height / 27,
              backgroundImage: const AssetImage(AssetPath.ductrong),
            ),
            Container(
              width: size.width / 1.5,
              height: size.height / 14,
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Lê Đức Trọng',
                            style: TxtStyle.heading4,
                            overflow: TextOverflow.ellipsis),
                        Text('28 Mar',
                            style: TxtStyle.heading4,
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                    const Text(
                        'hello xin chao xa qua nhi ca alibaba obama an hot vit lon',
                        style: TxtStyle.heading5l,
                        overflow: TextOverflow.ellipsis)
                  ]),
            )
          ])
        ]));
  }
}
