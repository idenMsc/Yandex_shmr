import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:shmr_25/widgets/CustomListItem.dart';
import 'package:shmr_25/widgets/FZSearchWiget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  final _categories = [
    ['Аренда квартиры', '🏡'],
    ['Одежда', '👗'],
    ['На собачку', '🐶'],
    ['Ремонт квартиры'],
    ['Продукты', '🍭'],
    ['Спортзал', '🏋️'],
    ['Медицина', '💊'],
  ];

  Fuzzy search = Fuzzy([]);
  String searchQuery = "";

  String searchLetters(String name) {
    List<String> words = name.split(" ");
    String result = words[0][0];
    if (words.length > 1) {
      result += words[1][0].toUpperCase();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var fuseList = [];

    for (var category in _categories) {
      fuseList.add(category[0]);
    }

    List searchWords =
        Fuzzy(fuseList).search(searchQuery).map((e) => e.item).toList();

    return Scaffold(
        body: Column(
      children: [
        FZSearchWiget(
          onTapSearch: (text) {
            setState(() => searchQuery = text);
          },
          onSearchReset: () {
            setState(() => searchQuery = "");
          },
        ),
        Expanded(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: searchWords.length,
          itemBuilder: (builder, index) {
            var category = _categories
                .where((item) => item[0] == searchWords[index])
                .first;
            String? emoji = category.length > 1 ? category[1] : null;

            return CustomListItem(
              height: height * 0.077,
              paddingLeft: width * 0.04,
              paddingRight: width * 0.04,
              title: searchWords[index],
              wrapEmoji: true,
              emoji: emoji,
            );
          },
        ))
      ],
    ));
  }
}
