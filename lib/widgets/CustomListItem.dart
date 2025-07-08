import 'package:flutter/material.dart';
import 'package:shmr_25/widgets/appSvg.dart';

class CustomListItem extends StatefulWidget {
  const CustomListItem({
    super.key,
    required this.height,
    required this.paddingLeft,
    required this.paddingRight,
    required this.title,
    this.subtitle,
    this.trailing,
    this.emoji,
    this.bgColor,
    this.borderColor,
    this.emojiBgColor,
    this.emojiStyle,
    this.icon,
    this.titleColor,
    this.wrapEmoji,
    this.svg,
    this.isEditing,
    this.onTitleUpdate,
    this.inputController,
    this.placeholder,
    this.autoFocus,
    this.inputWidth,
  });

  final double height;
  final double paddingLeft;
  final double paddingRight;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? emoji;
  final Color? bgColor;
  final Color? borderColor;
  final bool? wrapEmoji;
  final Color? emojiBgColor;
  final TextStyle? emojiStyle;
  final Icon? icon;
  final AppSvg? svg;
  final Color? titleColor;
  final bool? isEditing;
  final void Function(String)? onTitleUpdate;
  final TextEditingController? inputController;
  final String? placeholder;
  final bool? autoFocus;
  final double? inputWidth;

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.height,
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: Border(
          bottom: BorderSide(
            color: widget.borderColor ?? const Color.fromRGBO(202, 196, 208, 1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: mediaWidth * 0.038),
                child: Row(
                  children: [
                    if (widget.emoji != null)
                      (widget.wrapEmoji ?? false)
                          ? Container(
                              height: mediaHeight * 0.026,
                              width: mediaWidth * 0.058,
                              decoration: BoxDecoration(
                                color: widget.emojiBgColor ??
                                    const Color.fromRGBO(212, 250, 230, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.emoji!,
                                  style: widget.emojiStyle,
                                ),
                              ),
                            )
                          : (widget.svg ?? const SizedBox()),
                    if (widget.icon != null) widget.icon!,
                  ],
                ),
              ),
              _buildTextBlock(context),
            ],
          ),
          widget.trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildTextBlock(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (widget.subtitle != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(color: widget.titleColor)),
          SizedBox(
            width: w * 0.4,
            child: Text(
              widget.subtitle!,
              style: const TextStyle(
                color: Color.fromRGBO(73, 69, 79, 1),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    if (widget.isEditing == true) {
      return SizedBox(
        width: widget.inputWidth ?? w * 0.45,
        child: TextFormField(
          controller: widget.inputController,
          autofocus: widget.autoFocus ?? false,
          maxLines: 1,
          onChanged: widget.onTitleUpdate,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: widget.placeholder ?? widget.title,
            hintStyle: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }

    return Text(widget.title, style: TextStyle(color: widget.titleColor));
  }
}
