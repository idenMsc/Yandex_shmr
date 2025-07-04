import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tab_item_data.dart';
import '../../../core/utils/constants.dart';

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
      color: AppColors.surfaceContainer,
      height: AppSizes.bottomNavBarHeight,
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppSizes.navBarBorderRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tabs[index].assetPath != null
                        ? (tabs[index].assetPath!.endsWith('.svg')
                            ? SvgPicture.asset(
                                tabs[index].assetPath!,
                                height: AppSizes.iconSize,
                                width: AppSizes.iconSize,
                              )
                            : Image.asset(
                                tabs[index].assetPath!,
                                height: AppSizes.iconSize,
                                width: AppSizes.iconSize,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ))
                        : Icon(
                            tabs[index].icon,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                            size: AppSizes.iconSize,
                          ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[index].label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
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
