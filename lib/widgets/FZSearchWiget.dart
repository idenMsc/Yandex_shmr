import 'package:flutter/material.dart';

class FZSearchWiget extends StatefulWidget {
  const FZSearchWiget({super.key, this.onTapSearch, required this.onSearchReset});
  final void Function(String)? onTapSearch;
  final void Function() onSearchReset;

  @override
  State<FZSearchWiget> createState() => _FZSearchWigetState();
}

class _FZSearchWigetState extends State<FZSearchWiget> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container (
      height: height * 0.062,
      decoration: const BoxDecoration(
        border: Border (
          bottom: BorderSide(color: Color.fromRGBO(202, 196, 208, 1)),
        ),
        color: Color.fromRGBO(236, 230, 240, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (value) => widget.onTapSearch!(value),
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Найти статью",
                suffixIcon: const Icon(
                  Icons.search_outlined,
                  color: Color.fromRGBO(73, 60, 75, 1),
                ),
                contentPadding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.04,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
