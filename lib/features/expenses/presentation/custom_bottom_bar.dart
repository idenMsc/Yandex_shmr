import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tab_item_data.dart';

class CustomBottomBar extends StatelessWidget {
  final List<TabItemData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F4FA),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFDFFFE2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tabs[index].assetPath != null
                        ? (tabs[index].assetPath!.endsWith('.svg')
                            ? SvgPicture.asset(
                                tabs[index].assetPath!,
                                height: 32,
                                width: 32,
                              )
                            : Image.asset(
                                tabs[index].assetPath!,
                                height: 32,
                                width: 32,
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey[700],
                              ))
                        : Icon(
                            tabs[index].icon,
                            color: isSelected ? Colors.green : Colors.grey[700],
                            size: 32,
                          ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[index].label,
                      style: TextStyle(
                        color: isSelected ? Colors.green : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
