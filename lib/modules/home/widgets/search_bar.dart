import 'package:flutter/material.dart';
import 'package:gotechjsc_app/config/themes/app_color.dart';
import 'package:gotechjsc_app/config/themes/text_style.dart';
import 'package:gotechjsc_app/constants/assets_path.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 16,
      margin: const EdgeInsets.only(left: 24, bottom: 15, right: 24),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: DarkTheme.veryDark, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: TextField(
            decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TxtStyle.searchText,
                border: InputBorder.none),
          )),
          Container(
            height: size.height / 16,
            decoration: BoxDecoration(
                color: DarkTheme.lightGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(AssetPath.iconSearch),
          )
        ],
      ),
    );
  }
}
